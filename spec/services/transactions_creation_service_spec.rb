# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsCreationService, type: :service do
  let(:user) { create(:user) }

  let(:valid_params) do
    ActionController::Parameters.new({
                                       transactions: [
                                         { transaction_id: SecureRandom.uuid, points: 100, user_id: user.id },
                                         { transaction_id: SecureRandom.uuid, points: 200, user_id: user.id }
                                       ]
                                     })
  end

  let(:invalid_params) do
    ActionController::Parameters.new({
                                       transactions: [
                                         { transaction_id: SecureRandom.uuid, user_id: user.id, points: nil },
                                         { transaction_id: nil, points: 100, user_id: user.id },
                                         { transaction_id: SecureRandom.uuid, points: nil, user_id: user.id }
                                       ]
                                     })
  end

  let(:mixed_params) do
    ActionController::Parameters.new({
                                       transactions: [
                                         { transaction_id: SecureRandom.uuid, points: 100, user_id: user.id },
                                         { transaction_id: nil, points: 200, user_id: user.id },
                                         { transaction_id: SecureRandom.uuid, points: 300, user_id: user.id }
                                       ]
                                     })
  end

  describe '#call' do
    context 'with valid params' do
      before do
        @service = TransactionsCreationService.new(valid_params)
        @status, @response = @service.call
      end

      it 'returns created status' do
        expect(@status).to eq(:created)
      end

      it 'returns success status in response' do
        expect(@response[:status]).to eq('success')
      end

      it 'returns correct processed count in response' do
        expect(@response[:processed_count]).to eq(2)
      end
    end

    context 'with mixed params' do
      before do
        @service = TransactionsCreationService.new(mixed_params)
        @status, @response = @service.call
      end

      it 'returns created status' do
        expect(@status).to eq(:created)
      end

      it 'returns success status in response' do
        expect(@response[:status]).to eq('success')
      end

      it 'returns correct processed count in response' do
        expect(@response[:processed_count]).to eq(2)
      end
    end

    context 'with invalid params' do
      before do
        @service = TransactionsCreationService.new(invalid_params)
        @status, @response = @service.call
      end

      it 'returns unprocessable_entity status' do
        expect(@status).to eq(:unprocessable_entity)
      end

      it 'returns failed status in response' do
        expect(@response[:status]).to eq('failed')
      end

      it 'returns correct error count in response' do
        expect(@response[:errors].count).to eq(3)
      end
    end

    context 'with duplicate transaction_id' do
      before do
        transaction_id = SecureRandom.uuid
        params = ActionController::Parameters.new({
                                                    transactions: [
                                                      { transaction_id:, points: 100, user_id: user.id },
                                                      { transaction_id:, points: 200, user_id: user.id },
                                                      { transaction_id: 'random_id', points: 200, user_id: user.id }
                                                    ]
                                                  })
        @service = TransactionsCreationService.new(params)
        @status, @response = @service.call
      end

      it 'returns created status' do
        expect(@status).to eq(:created)
      end

      it 'returns success status in response' do
        expect(@response[:status]).to eq('success')
      end

      it 'returns correct processed count in response' do
        expect(@response[:processed_count]).to eq(2)
      end
    end
  end
end
