require 'rubygems'

require 'bundler'
Bundler.setup :default, :test
ENV["DATABASE_URL"] ||= "postgres:///queue_classic_test"

require "minitest/autorun"

class QCTest < Minitest::Test

  def setup
    init_db
    QC::Later::Setup.create
  end

  def teardown
    QC::Later::Setup.drop
    QC.delete_all
  end

  def init_db
    c = QC::ConnAdapter.new
    c.execute("SET client_min_messages TO 'warning'")
    QC::Setup.drop(c.connection)
    QC::Setup.create(c.connection)
    # c.execute(File.read('./test/helper.sql'))
    c.disconnect
  end

  def capture_stderr_output
    original_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = original_stderr
  end

  def capture_debug_output
    original_debug = ENV['DEBUG']
    original_stdout = $stdout

    ENV['DEBUG'] = "true"
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    ENV['DEBUG'] = original_debug
    $stdout = original_stdout
  end

  def with_env(temporary_environment)
    original_environment = {}
    temporary_environment.each do |name, value|
      original_environment[name] = ENV[name]
      ENV[name] = value
    end
    yield
  ensure
    original_environment.each { |name, value| ENV[name] = value }
  end

  def execute(s)
    QC.default_conn_adapter.execute(s)
  end

  def num_jobs
    execute("SELECT COUNT(*) FROM #{QC::Later::TABLE_NAME}")["count"].to_i
  end
end
