class TransactionCreationService
  attr_reader :params, :http_status, :response

  def initialize(params)
    @params = params
    @http_status = nil
    @response = nil
  end

  def create!
    transaction = Transaction.new(transaction_params)
    if transaction.save
      @http_status = :created
      @response = { status: 'success', transaction_id: transaction.id }
    else
      @http_status = :unprocessable_entity
      @response = { status: 'failed', errors: transaction.errors.full_messages }
    end

    [http_status, response]
  end

  private

  def transaction_params
    params.permit(:transaction_id, :points, :user_id)
  end
end
