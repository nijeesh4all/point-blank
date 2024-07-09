class ProcessTransactionsJob < ApplicationJob
  queue_as :default

  def perform(transaction_ids)
    user_ids = Transaction.where(id: transaction_ids).select(:user_id).distinct
    user_ids.find_each do |user_id|
      ProcessUserTransactionsJob.perform_later(user_id)
    end
  end
end
