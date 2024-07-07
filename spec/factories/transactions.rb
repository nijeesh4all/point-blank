# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    points { 1 }
    user_id {}
    state {}
  end
end
