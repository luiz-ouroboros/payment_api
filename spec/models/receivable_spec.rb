require 'rails_helper'

RSpec.describe Receivable, type: :model do
  let(:receivable) { create(:receivable) }
  let(:payment_transaction) { receivable.payment_transaction }

  describe '#retention_value' do
    it 'when fee is 9.9 and amount is 1000.00 and installments is 10 then return 9.90' do
      payment_transaction.update!(amount: 1000.00, installments: 10)
      create(:installment_fee,
        gateway: payment_transaction.gateway,
        installments: payment_transaction.installments,
        fee_percentage: 9.9
      )
      expected = 9.90

      expect(receivable.retention_value).to eq(expected)
    end

    it 'when fee transaction is nil returns nil' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect(receivable.retention_value).to be_nil
    end

    it 'when amount transaction is nil returns nil' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect(receivable.retention_value).to be_nil
    end
  end

  describe '#retention_value!' do
    it 'when fee transaction is nil raise a ArgumentError' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect { receivable.retention_value! }.to raise_error(
        ArgumentError, 'fee or amount of payment_transaction is nil'
      )
    end

    it 'when amount is nil raise a ArgumentError' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect { receivable.retention_value! }.to raise_error(
        ArgumentError, 'fee or amount of payment_transaction is nil'
      )
    end
  end

  describe '#transfer_value' do
    it 'when fee is 9.9 and amount is 1000.00 and installments is 10 then return 90.10' do
      payment_transaction.update!(amount: 1000.00, installments: 10)
      create(:installment_fee,
        gateway: payment_transaction.gateway,
        installments: payment_transaction.installments,
        fee_percentage: 9.9
      )
      expected = 90.10

      expect(receivable.transfer_value).to eq(expected)
    end

    it 'when fee transaction is nil returns nil' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect(receivable.transfer_value).to be_nil
    end

    it 'when amount transaction is nil returns nil' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect(receivable.transfer_value).to be_nil
    end
  end

  describe '#transfer_value!' do
    it 'when fee transaction is nil raise a ArgumentError' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect { receivable.transfer_value! }.to raise_error(
        ArgumentError, 'fee or amount of payment_transaction is nil'
      )
    end

    it 'when amount is nil raise a ArgumentError' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect { receivable.transfer_value! }.to raise_error(
        ArgumentError, 'fee or amount of payment_transaction is nil'
      )
    end
  end
end
