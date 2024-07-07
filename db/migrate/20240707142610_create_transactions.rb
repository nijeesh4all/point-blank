# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id, null: false, index: { unique: true }
      t.integer :points, null: false
      t.string :user_id, null: false
      t.integer :state, null: false, default: 0

      t.timestamps
    end
  end
end
