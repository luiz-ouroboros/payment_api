class InstallmentFee < ApplicationRecord
  audited

  FEE_CONFIGS = (1..12).map do |i|
    {
      installments: i,
      fee_percentage: (i * 0.99).round(2),
      gateway: 'fake_gateway'
    }
  end.freeze

  def self.setup
    FEE_CONFIGS.each do |config|
      unless InstallmentFee.exists?(gateway: config[:gateway], installments: config[:installments])
        InstallmentFee.create!(config)
      end
    end
  end
end
