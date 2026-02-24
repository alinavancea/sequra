require 'rails_helper'

RSpec.describe Sequra::Reports::MimimumMonthlyFeesReport do
  let(:merchant1) { Merchant.create(reference: "merchant1", email: "merchant1@test.com", live_on: "2022-01-01") }
  let(:merchant2) { Merchant.create(reference: "merchant2", email: "merchant2@test.com", live_on: "2022-01-01") }

  let(:report) { Sequra::Reports::MimimumMonthlyFeesReport.new.generate }

  before do
    MerchantMinimumMonthlyCommission.create(
      created_at: Date.parse("2026-01-01"),
      commission_date: Date.parse("2026-01-01"),
      merchant: merchant1,
      minimum_monthly_comission: 10
      )
    MerchantMinimumMonthlyCommission.create(
      created_at: Date.parse("2026-02-01"),
      commission_date: Date.parse("2026-02-01"),
      merchant: merchant1,
      minimum_monthly_comission: 9,
      )
    MerchantMinimumMonthlyCommission.create(
      created_at: Date.parse("2025-02-01"),
      commission_date: Date.parse("2025-02-01"),
      merchant: merchant1,
      minimum_monthly_comission: 5,
      )
    MerchantMinimumMonthlyCommission.create(
      created_at: Date.parse("2025-02-01"),
      commission_date: Date.parse("2025-02-01"),
      merchant: merchant2,
      minimum_monthly_comission: 5,
      )
  end

  describe "generates the report" do
    it "has 2 rows" do
      expect(report.to_a.size).to eq(2)
    end

    it "has correct data for year 2025" do
      data = report.select { |row| row.year == 2025.0 }.first

      expect(data.monthly_fees_count).to eq(2)
      expect(data.minimum_monthly_comission.to_f).to eq(10)
    end

    it "has correct data for year 2026" do
      data = report.select { |row| row.year == 2026.0 }.first

      expect(data.monthly_fees_count).to eq(2)
      expect(data.minimum_monthly_comission.to_f).to eq(19)
    end
  end
end
