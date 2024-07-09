# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessUserTransactionsJob, type: :job do
  let(:user) { create(:user, points: 0) }
  let!(:pending_transactions) do
    create_list(:transaction, 2, user: user, state: 'pending', points: 50)
  end
  let!(:committed_transaction) do
    create(:transaction, user: user, state: 'committed', points: 100)
  end

  describe '#perform' do
    it 'processes pending transactions' do
      expect {
        described_class.new.perform(user.id)
        user.reload
      }.to change { user.points }.by(100)

      pending_transactions.each do |transaction|
        expect(transaction.reload.state).to eq('committed')
      end
    end

    it 'does not process committed transactions' do
      described_class.new.perform(user.id)

      expect(committed_transaction.reload.state).to eq('committed')
      expect(user.reload.points).not_to eq(150) # points remain unchanged from committed_transaction
    end

    it 'raises an error if user save fails' do
      allow_any_instance_of(User).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect {
        described_class.new.perform(user.id)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'unique jobs' do
    before do
      Sidekiq::Testing.fake!
    end

    it 'processes only one job when duplicate jobs are enqueued' do
      described_class.perform_later(user.id)
      described_class.perform_later(user.id)

      expect {
        Sidekiq::Worker.drain_all
      }.to change { user.reload.points }.by(100)
    end
  end
end
