require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "disbursement_frequencies" do
    it "has daily and weekly values" do
      expect(Merchant.disbursement_frequencies).to eq({ "daily" => 0, "weekly" => 1 })
    end

    it "creates a record with daily as default" do
      merchant = Merchant.create!(
        reference: 'REF001',
        email: 'test@example.com',
        minimum_monthly_fee: 10.0
      )

      expect(merchant.daily?).to be true
      expect(merchant.weekly?).to be false
    end

    it "creates a record with weekly when set" do
      merchant = Merchant.create!(
        reference: 'REF001',
        email: 'test@example.com',
        disbursement_frequency: :weekly,
        minimum_monthly_fee: 10.0
      )

      expect(merchant.daily?).to be false
      expect(merchant.weekly?).to be true
    end
    
    it "fails when using a differnt value" do
      expect { Merchant.create!(
        reference: 'REF001',
        email: 'test@example.com',
        disbursement_frequency: :weeklyy,
        minimum_monthly_fee: 10.0
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Disbursement frequency is not included in the list")
    end
  end

  describe "reference" do
    it "should normalize" do
      merchant = Merchant.create!(
        reference: 'Test Shop',
        email: 'test@example.com',
        minimum_monthly_fee: 10.0        
      )

      expect(merchant.reference).to eq("test_shop")
    end
  end
end