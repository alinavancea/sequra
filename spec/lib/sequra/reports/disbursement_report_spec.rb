require 'rails_helper'

RSpec.describe Sequra::Reports::DisbursementReport do
  let(:merchant1) { Merchant.create(reference: "merchant1", email: "merchant1@test.com", live_on: "2022-01-01") }
  let(:merchant2) { Merchant.create(reference: "merchant2", email: "merchant2@test.com", live_on: "2022-01-01") }
  let(:report) { Sequra::Reports::DisbursementReport.new.generate_by_created_at }

  before do
     Disbursement.create!(
      created_at: Date.parse("2026-02-01"),
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
      created_at: Date.parse("2025-02-01"),
      reference: "#{merchant2.id}_2025-02-01",
      merchant: merchant2,
      status: :paid,
      total_amount: 85940.73,
      sequra_commission_fee: 0.0085,
      sequra_commission: 730.5,
      merchant_amount: 85210.23
      )

    Disbursement.create!(
      created_at: Date.parse("2026-02-01"),
      reference: "#{merchant2.id}_2026-02-01",
      merchant: merchant2,
      status: :pending,
      total_amount: 85940.73,
      sequra_commission_fee: 0.0085,
      sequra_commission: 730.5,
      merchant_amount: 85210.23
      )
  end

  describe "generates the report" do
    it "has 2 rows" do
      expect(report.to_a.size).to eq(2)
    end

    it "has correct data for year 2025" do
      data = report.select { |row| row.year == 2025.0 }.first

      expect(data.disbursements_count).to eq(2)
      expect(data.sequra_commission.to_f).to eq(194246.42)
      expect(data.merchant_amount.to_f).to eq(22658273.71)
    end

    it "has correct data for year 2026" do
      data = report.select { |row| row.year == 2026.0 }.first

      expect(data.disbursements_count).to eq(1)
      expect(data.sequra_commission.to_f).to eq(193515.92)
      expect(data.merchant_amount.to_f).to eq(22573063.48)
    end
  end
end
