# coding: utf-8
class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Sidekiq::Logging.logger.info "サンプルジョブを実行した"
  end
end
