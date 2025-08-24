require 'rails'
require 'active_job'
require 'active_job/railtie'

class TestApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = 'secret_key_base'
  config.active_job.queue_adapter = :test
  config.logger = Logger.new($stdout)
end
Rails.application.initialize!

class BuggyJob < ActiveJob::Base
  def perform
    File.write('buggy_job_output.txt', 'This is a buggy job output.')
  end
end

RSpec.describe 'ActiveJob Bug Report' do
  it 'enqueues BuggyJob' do
    BuggyJob.perform_later
    jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
    expect(jobs.any? { |job| job[:job] == BuggyJob }).to be true
  end
end
