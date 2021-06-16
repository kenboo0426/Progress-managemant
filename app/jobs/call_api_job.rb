class CallApiJob < ApplicationJob
  self.queue_adapter = :delayed_job
  queue_as :default

  def perform(*args)
    puts "aaa"
  end
end
