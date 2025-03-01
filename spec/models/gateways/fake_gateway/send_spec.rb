require 'rails_helper'

RSpec.describe Gateways::FakeGateway::Send do
  let(:payment_transaction) { create(:payment_transaction) }

  context 'successfull' do
    it 'When the payment transaction has a even number of installments' do
      payment_transaction.update!(installment: 2)

      result = described_class.call(payment_transaction: payment_transaction)

      expect(result).to be_success
      expect(result[:payment_transaction]).to be_approved

      payment_transaction.reload

      expect(payment_transaction.receivables.count).to be_eql(2)
    end
  end

  context 'failure' do
    it 'When the payment transaction has a odd number of installments' do
      payment_transaction.update!(installment: 3)
      pattern = { installment: [I18n.t('errors.gateways.fake_gateway.installment_odd')] }

      result = described_class.call(payment_transaction: payment_transaction)

      expect(result).to be_failure
      expect(result.data).to eq(pattern)

      payment_transaction.reload

      expect(payment_transaction).to be_reproved
      expect(payment_transaction.receivables).to be_none
    end
  end
end
