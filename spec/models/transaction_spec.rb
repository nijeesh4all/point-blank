# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:transaction_id) }
  it { should validate_presence_of(:points) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:status) }

  it {
    should define_enum_for(:state).with_values(pending: 0, committed: 1, rejected: 2)
                                   .backed_by_column_of_type(:integer).with_prefix
  }
end
