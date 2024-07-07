class Api::V1::TransactionsController < Api::ApiControllerBase
  def single
    creation_service = TransactionCreationService.new(params)
    http_status, response = creation_service.create!
    render json: response, status: http_status
  end

  def bulk
  end
end
