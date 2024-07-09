# frozen_string_literal: true

class TransactionCreationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def create!
    transaction = Transaction.new(transaction_params)
    if transaction.save
      process_transaction(transaction)

      [
        :created,
        { status: 'success', transaction_id: transaction.id }
      ]
    else
      [
        :unprocessable_entity,
        { status: 'failed', errors: transaction.errors.full_messages }
      ]
    end
  end

  private

  def process_transaction(transaction)
    ProcessUserTransactionsJob.perform_later(transaction.user_id)
  end

  def transaction_params
    params.permit(:transaction_id, :points, :user_id)
  end
end
