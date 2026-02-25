require 'rails_helper'

RSpec.describe Sequra::Services::MinimumMonthlyFees do
  let(:merchant1) { create(:merchant, minimum_monthly_fee: 30) }
  let(:merchant2) { create(:merchant, minimum_monthly_fee: 10) }

  let(:service) { Sequra::Services::MinimumMonthlyFees.new }

  before do
    create(:disbursement,
      created_at: Date.parse("2026-01-02"),
      merchant: merchant1,
      status: :paid,
      total_amount: 22_766_579.4,
      sequra_commission: 193_515.92,
      merchant_amount: 22_573_063.48)

    create(:disbursement,
      created_at: Date.parse("2025-02-01"),
      merchant: merchant1,
      status: :paid,
      total_amount: 22_766_579.4,
      sequra_commission: 193_515.92,
      merchant_amount: 22_573_063.48)

    create(:disbursement,
      created_at: Date.parse("2026-01-02"),
      merchant: merchant2,
      status: :paid,
      total_amount: 100,
      sequra_commission: 0.95,
      merchant_amount: 99.05)

    create(:disbursement,
      created_at: Date.parse("2026-01-02"),
      merchant: merchant2,
      status: :failed,
      total_amount: 85_940.73,
      sequra_commission: 730.5,
      merchant_amount: 85_210.23)
  end

  describe "calculate" do
    it "creates merchant_minimum_monthly_commissions for merchant1" do
      service.calculate(Date.parse("2026-01-01")..Date.parse("2026-01-31"))

      expect(MerchantMinimumMonthlyCommission.count).to eq(1)

      commission = MerchantMinimumMonthlyCommission.last

      expect(commission.merchant_id).to eq(merchant2.id)
      expect(commission.minimum_monthly_comission.to_f).to eq(10 - 0.95)
    end
  end
end
