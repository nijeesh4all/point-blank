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
  end

  describe '#create!' do
    context 'when transaction is successfully created' do
      before do
        allow_any_instance_of(Transaction).to receive(:save).and_return(true)
        allow_any_instance_of(Transaction).to receive(:id).and_return(1)
      end

      it 'returns created status' do
        http_status, _response = service.create!
        expect(http_status).to eq(:created)
      end

      it 'returns success response with transaction_id' do
        _http_status, response = service.create!
        expect(response).to eq({ status: 'success', transaction_id: 1 })
      end

      it 'calls ProcessUserTransactionsJob with correct user_id' do
        expect(ProcessUserTransactionsJob).to receive(:perform_later).with("1")
        service.create!
      end
    end

    context 'when transaction creation fails' do
      let(:service) { TransactionCreationService.new(invalid_params) }

      before do
        transaction = double('Transaction', save: false, errors: double('Errors', full_messages: ["Transaction id can't be blank"]))
        allow(Transaction).to receive(:new).and_return(transaction)
      end

      it 'returns unprocessable_entity status' do
        http_status, _response = service.create!
        expect(http_status).to eq(:unprocessable_entity)
      end

      it 'returns failed response with error messages' do
        _http_status, response = service.create!
        expect(response).to eq({ status: 'failed', errors: ["Transaction id can't be blank"] })
      end

      it 'does not call ProcessUserTransactionsJob' do
        expect(ProcessUserTransactionsJob).not_to receive(:perform_later)
        service.create!
      end
    end
  end
end
