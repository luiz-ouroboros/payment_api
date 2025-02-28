class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :installment, null: false
      t.string :payment_method, null: false
      t.string :status, null: false

      t.datetime :approved_at
      t.datetime :reproved_at
      t.string :gateway, null: false

      t.timestamps
    end
  end
end
