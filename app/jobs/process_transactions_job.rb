# frozen_string_literal: true

class ProcessTransactionsJob < ApplicationJob
  queue_as :default

  def perform(transaction_ids)
    user_ids = Transaction.state_pending
                          .where(id: transaction_ids)
                          .distinct(:user_id)
                          .select(:user_id)
                          .pluck(:user_id)

    # TODO: based on the scale of the application, we can batch the transactions
    #       but for now this is fine
    user_ids.each do |user_id|
      ProcessUserTransactionsJob.perform_later(user_id)
    end
  end
end
