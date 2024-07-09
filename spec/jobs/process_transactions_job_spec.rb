# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTransactionsJob, type: :job do
  let(:transaction_ids) { [1, 2, 3] }
  let(:users_with_pending_transactions) { [1, 2] }

  describe '#perform' do
    before do
      allow(Transaction).to receive_message_chain(:state_pending, :where).and_return(Transaction.where(id: transaction_ids))
      allow(Transaction).to receive_message_chain(:state_pending, :where, :distinct, :select, :pluck).and_return(users_with_pending_transactions)
    end

    it 'enqueues ProcessUserTransactionsJob for each user with pending transactions' do
      users_with_pending_transactions.each do |user_id|
        expect(ProcessUserTransactionsJob).to receive(:perform_later).with(user_id)
      end

      described_class.new.perform(transaction_ids)
    end

    it 'does not enqueue ProcessUserTransactionsJob if no users have pending transactions' do
      allow(Transaction).to receive_message_chain(:state_pending, :where, :distinct, :select, :pluck).and_return([])

      expect(ProcessUserTransactionsJob).not_to receive(:perform_later)

      described_class.new.perform(transaction_ids)
    end
  end
end
