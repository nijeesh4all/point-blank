# frozen_string_literal: true

class ProcessUserTransactionsJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 5,
                  lock: :until_executed,
                  on_conflict: {
                    client: :log,
                    server: :replace
                  }

  def perform(user_id)
    pending_transactions = Transaction.state_pending.where(user_id:)
    user = User.find(user_id)

    pending_transactions.find_each do |transaction|
      transaction.with_lock do
        next unless transaction.state_pending?

        user.with_lock do
          user.points += transaction.points
          user.save!
        end

        transaction.state_committed!
      end
    end
  end
end
