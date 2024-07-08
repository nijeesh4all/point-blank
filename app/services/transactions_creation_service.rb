# frozen_string_literal: true

class TransactionsCreationService
  attr_reader :params

  BATCH_SIZE = 10

  def initialize(params)
    @params = params

    @http_status = nil
    @response = nil
  end

  def call
    transactions = transactions_params.map(&:to_h)
    import_result = Transaction.import(transactions, batch_size: BATCH_SIZE, on_duplicate_key_ignore: true)
    response_attrs(import_result)
  end

  private

  def response_attrs(import_result)
    if import_result.ids.count.zero?
      [
        :unprocessable_entity,
        { status: 'failed', errors: import_result.failed_instances.map(&:errors) }
      ]
    else
      [:created, { status: 'success', processed_count: import_result.ids.count }]
    end
  end

  def transactions_params
    params.require(:transactions).map do |transaction|
      transaction.permit(:transaction_id, :points, :user_id)
    end
  end
end
