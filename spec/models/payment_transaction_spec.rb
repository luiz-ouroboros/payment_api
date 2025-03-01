require 'rails_helper'

RSpec.describe PaymentTransaction, type: :model do
  let(:payment_transaction) { create(:payment_transaction) }

  describe '#fee' do
    context 'when a matching InstallmentFee record exists' do
      it 'returns the fee_percentage from the InstallmentFee record' do
        create(:installment_fee,
          gateway: payment_transaction.gateway,
          installments: payment_transaction.installments,
          fee_percentage: 0.99
        )

        expect(payment_transaction.fee).to eq(0.99)
      end
    end

    context 'when no matching InstallmentFee record exists' do
      it 'returns nil' do
        expect(payment_transaction.fee).to be_nil
      end
    end
  end

  describe '#retention_value' do
    it 'when fee is 9.9 and amount is 1000.00 return 99.0' do
      payment_transaction.update!(amount: 1000.00, installments: 10)
      create(:installment_fee,
        gateway: payment_transaction.gateway,
        installments: payment_transaction.installments,
        fee_percentage: 9.9
      )
      expected = 99.0

      expect(payment_transaction.retention_value).to eq(expected)
    end

    it 'when fee is nil returns nil' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect(payment_transaction.retention_value).to be_nil
    end

    it 'when amount is nil returns nil' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect(payment_transaction.retention_value).to be_nil
    end
  end

  describe '#retention_value!' do
    it 'when fee is nil raise a ArgumentError' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect { payment_transaction.retention_value! }.to raise_error(ArgumentError, 'fee or amount is nil')
    end

    it 'when amount is nil raise a ArgumentError' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect { payment_transaction.retention_value! }.to raise_error(ArgumentError, 'fee or amount is nil')
    end
  end


  describe '#transfer_value' do
    it 'when fee is 9.9 and amount is 1000.00 return 901.00' do
      payment_transaction.update!(amount: 1000.00, installments: 10)
      create(:installment_fee,
        gateway: payment_transaction.gateway,
        installments: payment_transaction.installments,
        fee_percentage: 9.9
      )
      expected = 901.00

      expect(payment_transaction.transfer_value).to eq(expected)
    end

    it 'when fee is nil returns nil' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect(payment_transaction.transfer_value).to be_nil
    end

    it 'when amount is nil returns nil' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect(payment_transaction.transfer_value).to be_nil
    end
  end

  describe '#transfer_value!' do
    it 'when fee is nil raise a ArgumentError' do
      expect(payment_transaction.amount).not_to be_nil
      expect(payment_transaction.fee).to be_nil

      expect { payment_transaction.transfer_value! }.to raise_error(ArgumentError, 'fee or amount is nil')
    end

    it 'when amount is nil raise a ArgumentError' do
      payment_transaction.amount = nil

      expect(payment_transaction.fee).to be_nil
      expect { payment_transaction.transfer_value! }.to raise_error(ArgumentError, 'fee or amount is nil')
    end
  end
end
