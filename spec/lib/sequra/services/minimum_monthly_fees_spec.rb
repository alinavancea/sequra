require 'rails_helper'

RSpec.describe Sequra::Services::MinimumMonthlyFees do
  let(:merchant1) { Merchant.create(reference: "merchant1", email: "merchant1@test.com", live_on: "2022-01-01", minimum_monthly_fee: 30) }
  let(:merchant2) { Merchant.create(reference: "merchant2", email: "merchant2@test.com", live_on: "2022-01-01", minimum_monthly_fee: 10) }

  let(:service) { Sequra::Services::MinimumMonthlyFees.new }

  before do
     Disbursement.create!(
      created_at: Date.parse("2026-01-02"),
      merchant: merchant1,
      reference: "#{merchant1.id}_2026-02-01",
      status: :paid,
      total_amount: 22766579.4,
      sequra_commission_fee: 0.0085,
      sequra_commission: 193515.92,
      merchant_amount: 22573063.48
      )

    Disbursement.create!(
      created_at: Date.parse("2025-02-01"),
      reference: "#{merchant1.id}_2025-02-01",
      merchant: merchant1,
      status: :paid,
      total_amount: 22766579.4,
      sequra_commission_fee: 0.0085,
      sequra_commission: 193515.92,
      merchant_amount: 22573063.48
      )

    Disbursement.create!(
      created_at: Date.parse("2026-01-02"),
      reference: "#{merchant2.id}_2025-02-01",
      merchant: merchant2,
      status: :paid,
      total_amount: 100,
      sequra_commission_fee: 0.0095,
      sequra_commission: 0.95,
      merchant_amount: 99.05
      )

    Disbursement.create!(
      created_at: Date.parse("2026-01-02"),
      reference: "#{merchant2.id}_2026-02-01",
      merchant: merchant2,
      status: :failed,
      total_amount: 85940.73,
      sequra_commission_fee: 0.0085,
      sequra_commission: 730.5,
      merchant_amount: 85210.23
      )
  end

  describe "calculate" do
    it "creates merchant_minimum_monthly_commissions for merchant1" do
      service.calculate(Date.parse("2026-01-01") .. Date.parse("2026-01-31"))

      expect(MerchantMinimumMonthlyCommission.count).to eq(1)

      commission = MerchantMinimumMonthlyCommission.last

      expect(commission.merchant_id).to eq(merchant2.id)
      expect(commission.minimum_monthly_comission.to_f).to eq(10 - 0.95)
    end
  end
end
