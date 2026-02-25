require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "disbursement_frequencies" do
    it "has daily and weekly values" do
      expect(Merchant.disbursement_frequencies).to eq({ "daily" => 0, "weekly" => 1 })
    end

    it "creates a record with daily as default" do
      merchant = create(:merchant)

      expect(merchant.daily?).to be true
      expect(merchant.weekly?).to be false
    end

    it "creates a record with weekly when set" do
      merchant = create(:merchant, :weekly)

      expect(merchant.daily?).to be false
      expect(merchant.weekly?).to be true
    end

    it "fails when using a differnt value" do
      expect {
        create(:merchant, disbursement_frequency: "Other")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Disbursement frequency is not included in the list")
    end

    describe "normalize" do
      it "should normalize" do
        merchant = create(:merchant, disbursement_frequency: "Weekly")

        expect(merchant.daily?).to be false
        expect(merchant.weekly?).to be true
      end
    end
  end

  describe "#paid_disbursements_for" do
    let(:merchant) { create(:merchant) }

    before do
      create(:disbursement, merchant: merchant, reference: "jan_paid", status: :paid, created_at: Date.parse("2026-01-15"))
      create(:disbursement, merchant: merchant, reference: "feb_paid", status: :paid, created_at: Date.parse("2026-02-10"))
      create(:disbursement, merchant: merchant, reference: "jan_failed", status: :failed, created_at: Date.parse("2026-01-20"))
    end

    it "returns only paid disbursements within the given interval" do
      interval = Date.parse("2026-01-01")..Date.parse("2026-01-31")

      result = merchant.paid_disbursements_for(interval)

      expect(result.count).to eq(1)
      expect(result.first.status).to eq("paid")
    end

    it "returns no disbursements when none match the interval" do
      interval = Date.parse("2025-01-01")..Date.parse("2025-01-31")

      result = merchant.paid_disbursements_for(interval)

      expect(result.count).to eq(0)
    end
  end

  describe "reference" do
    describe "normalize" do
      context "when having a value" do
        it "should normalize" do
          merchant = create(:merchant, reference: "Test Shop")

          expect(merchant.reference).to eq("test_shop")
        end
      end

      context "when nil" do
        it "should raise error" do
          expect {
            create(:merchant, reference: nil, live_on: nil)
          }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Reference can't be blank, Live on can't be blank")
        end
      end
    end
  end
end
