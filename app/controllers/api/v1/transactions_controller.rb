# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < Api::ApiControllerBase
      def single
        creation_service = TransactionCreationService.new(params)
        http_status, response = creation_service.create!
        render json: response, status: http_status
      end

      def bulk
        creation_service = TransactionsCreationService.new(params)
        http_status, response = creation_service.call
        render json: response, status: http_status
      end
    end
  end
end
