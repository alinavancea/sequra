require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe "status" do
    it "has pending, paid, failed" do
      expect(Disbursement.statuses).to eq({ "pending" => 0, "paid" => 1, "failed" => 2 })
    end
  end

  describe "set_reference" do
    let(:merchant) {
      Merchant.create(reference: 'REF001',
        email: 'test@example.com',
        minimum_monthly_fee: 10.0,
        live_on: "2026-02-01")
    }

    let(:orders) { Order.create(merchant: merchant, external_id: "516c2b28eceb", amount: 100) }

    it "sets the reference" do
      disrembursment = Disbursement.create(merchant: merchant)

      expect(disrembursment.reference).to eq("#{disrembursment.created_at.to_date}_#{disrembursment.merchant.id}")
    end
  end
end
