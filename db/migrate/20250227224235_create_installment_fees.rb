class CreateInstallmentFees < ActiveRecord::Migration[8.0]
  def change
    create_table :installment_fees do |t|
      t.integer :installments, null: false
      t.decimal :fee_percentage, precision: 5, scale: 2, null: false
      t.timestamps
    end
  end
end
