class ProcessUserTransactionsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
  end
end
