$: << File.expand_path("spec")

require "spec_helper"
require "queue_classic/later"
include QC::Later::QueueExtensions

class QueueTest < QCTest

  def test_enqueue_in
    time_completed = Time.now + 2
    enqueue_in(1, "Kernel.puts", "hello world 1")
    assert_equal(1, num_jobs)

    QC::Later.tick while Time.now < time_completed

    assert_equal(0, num_jobs)
  end

  def test_enqueue_at
    time_completed = Time.now + 2
    enqueue_at(time_completed-1, "Kernel.puts", "hello ","world 2")
    assert_equal(1, num_jobs)

    QC::Later.tick while Time.now < time_completed

    assert_equal(0, num_jobs)
  end

end
