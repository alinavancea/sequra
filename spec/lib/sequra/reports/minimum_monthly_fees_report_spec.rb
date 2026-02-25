require 'rails_helper'

RSpec.describe Sequra::Reports::MinimumMonthlyFeesReport do
  let(:merchant1) { create(:merchant) }
  let(:merchant2) { create(:merchant) }

  let(:report) { Sequra::Reports::MinimumMonthlyFeesReport.new.generate }

  before do
    create(:merchant_minimum_monthly_commission,
      created_at: Date.parse("2026-01-01"),
      commission_date: Date.parse("2026-01-01"),
      merchant: merchant1,
      minimum_monthly_commission: 10)

    create(:merchant_minimum_monthly_commission,
      created_at: Date.parse("2026-02-01"),
      commission_date: Date.parse("2026-02-01"),
      merchant: merchant1,
      minimum_monthly_commission: 9)

    create(:merchant_minimum_monthly_commission,
      created_at: Date.parse("2025-02-01"),
      commission_date: Date.parse("2025-02-01"),
      merchant: merchant1,
      minimum_monthly_commission: 5)

    create(:merchant_minimum_monthly_commission,
      created_at: Date.parse("2025-02-01"),
      commission_date: Date.parse("2025-02-01"),
      merchant: merchant2,
      minimum_monthly_commission: 5)
  end

  describe "generates the report" do
    it "has 2 rows" do
      expect(report.to_a.size).to eq(2)
    end

    it "has correct data for year 2025" do
      data = report.select { |row| row.year == 2025.0 }.first

      expect(data.monthly_fees_count).to eq(2)
      expect(data.minimum_monthly_commission.to_f).to eq(10)
    end

    it "has correct data for year 2026" do
      data = report.select { |row| row.year == 2026.0 }.first

      expect(data.monthly_fees_count).to eq(2)
      expect(data.minimum_monthly_commission.to_f).to eq(19)
    end
  end
end
