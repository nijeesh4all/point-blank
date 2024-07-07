# frozen_string_literal: true

class Transaction < ApplicationRecord
  enum status: { pending: 0, committed: 1, rejected: 2 }, default: :pending

  belongs_to :user

  validates :transaction_id, presence: true
  validates :points, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
end
