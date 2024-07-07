# frozen_string_literal: true

class Transaction < ApplicationRecord
  enum state: { pending: 0, committed: 1, rejected: 2 }, _prefix: true

  belongs_to :user

  validates :transaction_id, presence: true
  validates :points, presence: true
  validates :user_id, presence: true
  validates :state, presence: true
end
