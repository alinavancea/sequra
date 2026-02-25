require 'rails_helper'

RSpec.describe Sequra::Reports::DisbursementReport do
  let(:merchant1) { create(:merchant) }
  let(:merchant2) { create(:merchant) }
  let(:report) { Sequra::Reports::DisbursementReport.new.generate_by_created_at }

  before do
    create(:disbursement,
      created_at: Date.parse("2026-02-01"),
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
      created_at: Date.parse("2025-02-01"),
      merchant: merchant2,
      status: :paid,
      total_amount: 85_940.73,
      sequra_commission: 730.5,
      merchant_amount: 85_210.23)

    create(:disbursement,
      created_at: Date.parse("2026-02-01"),
      merchant: merchant2,
      status: :pending,
      total_amount: 85_940.73,
      sequra_commission: 730.5,
      merchant_amount: 85_210.23)
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
