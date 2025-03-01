require 'rails_helper'

RSpec.describe InstallmentFee, type: :model do
  describe '.setup' do
    before do
      InstallmentFee.destroy_all
    end

    context 'when no records exist' do
      it 'creates 12 records with the correct fields' do
        expect { InstallmentFee.setup }.to change { InstallmentFee.count }.from(0).to(12)

        InstallmentFee::FEE_CONFIGS.each do |config|
          fee = InstallmentFee.find_by(gateway: config[:gateway], installments: config[:installments])
          expect(fee).not_to be_nil
          expect(fee.fee_percentage).to eq(config[:fee_percentage])
        end
      end
    end

    context 'when some records already exist' do
      it 'does not create duplicate entries' do
        InstallmentFee.create!(gateway: 'fake_gateway', installments: 1, fee_percentage: 0.99)

        expect { InstallmentFee.setup }.to change { InstallmentFee.count }.from(1).to(12)
        expect(InstallmentFee.where(gateway: 'fake_gateway', installments: 1).count).to eq(1)
      end
    end

    context 'when called twice consecutively' do
      it 'only creates 12 unique records' do
        expect { InstallmentFee.setup }.to change { InstallmentFee.count }.from(0).to(12)
        expect { InstallmentFee.setup }.not_to change { InstallmentFee.count }
      end
    end
  end
end
