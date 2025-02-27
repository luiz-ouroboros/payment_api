class CreateReceivables < ActiveRecord::Migration[8.0]
  def change
    create_table :receivables do |t|
      t.references :transaction, null: false, foreign_key: true
      t.integer :installment_number, null: false
      t.date :schedule_date, null: false
      t.date :liquidation_date
      t.string :status, default: 'pending', null: false
      t.datetime :pending_at
      t.datetime :settled_at
      t.decimal :amount_to_settle, precision: 10, scale: 2, null: false
      t.decimal :amount_settled, precision: 10, scale: 2, default: 0.0, null: false
      t.timestamps
    end
  end
end
