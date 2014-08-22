require "json"

require "queue_classic"
require "queue_classic/later/version"

module QC
  module Later

    TABLE_NAME = "queue_classic_later_jobs"

    module Setup
      extend self

      def create
        QC.default_conn_adapter.connection.transaction do
          QC.default_conn_adapter.execute("CREATE TABLE #{QC::Later::TABLE_NAME} (q_name varchar(255), method varchar(255), args text, not_before timestamptz)")
        end
      end

      def drop
        QC.default_conn_adapter.connection.transaction do
          QC.default_conn_adapter.execute("DROP TABLE IF EXISTS #{QC::Later::TABLE_NAME}")
        end
      end
    end

    module Queries
      extend self

      def insert(q_name, not_before, method, args)
        QC.log_yield(:action => "insert_later_job") do
          s = "INSERT INTO #{QC::Later::TABLE_NAME} (q_name, not_before, method, args) VALUES ($1, $2, $3, $4)"
          QC.default_conn_adapter.execute(s, q_name, not_before, method, JSON.dump(args))
        end
      end

      def delete_and_capture(not_before)
        s = "DELETE FROM #{QC::Later::TABLE_NAME} WHERE not_before <= $1 RETURNING *"
        # need to ensure we return an Array even if Conn.execute returns a single item
        [QC.default_conn_adapter.execute(s, not_before)].compact.flatten
      end
    end

    module QueueExtensions
      def enqueue_in(seconds, method, *args)
        enqueue_at(Time.now + seconds, method, *args)
      end

      def enqueue_at(not_before, method, *args)
        QC::Later::Queries.insert(name, not_before, method, args)
      end
    end

    extend self

    # run QC::Later.tick as often as necessary via your clock process
    def tick
      QC.default_conn_adapter.connection.transaction do
        QC::Later::Queries.delete_and_capture(Time.now).each do |job|
          queue = QC::Queue.new(job["q_name"])
          queue.enqueue(job["method"], *JSON.parse(job["args"]))
        end
      end
    end
  end
end

QC::Queue.send :include, QC::Later::QueueExtensions
