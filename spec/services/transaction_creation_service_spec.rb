# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionCreationService do
  let(:valid_params) { ActionController::Parameters.new({ transaction_id: 1, points: 100, user_id: 1 }) }
  let(:invalid_params) { ActionController::Parameters.new({ transaction_id: nil, points: 100, user_id: 1 }) }

  let(:service) { TransactionCreationService.new(valid_params) }
  describe '#initialize' do
    it 'initializes with params' do
      expect(service.params).to eq(valid_params)
    end

    it 'initializes with nil http_status and response' do
      expect(service.http_status).to be_nil
      expect(service.response).to be_nil
    end
  end

  describe '#create!' do
    context 'when transaction is successfully created' do
      before do
        allow_any_instance_of(Transaction).to receive(:save).and_return(true)
        allow_any_instance_of(Transaction).to receive(:id).and_return(1)
      end

      it 'returns created status and response' do
        http_status, response = service.create!

        expect(http_status).to eq(:created)
        expect(response).to eq({ status: 'success', transaction_id: 1 })
      end
    end

    context 'when transaction creation fails' do
      let(:service) { TransactionCreationService.new(invalid_params) }

      before do
        transaction = double('Transaction', save: false, errors: double('Errors',
                                                                        full_messages: ['Transaction id can\'t be blank']))
        allow(Transaction).to receive(:new).and_return(transaction)
      end

      it 'returns unprocessable_entity status and response with error message' do
        http_status, response = service.create!

        expect(http_status).to eq(:unprocessable_entity)
        expect(response).to eq({ status: 'failed', errors: ['Transaction id can\'t be blank'] })
      end
    end
  end
end
