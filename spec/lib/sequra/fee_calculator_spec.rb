require 'rails_helper'

RSpec.describe Sequra::FeeCalculator do
  describe ".rate_for_amount" do
    it "returns 1% for amounts under 50" do
      expect(Sequra::FeeCalculator.rate_for_amount(1)).to eq(0.01)
      expect(Sequra::FeeCalculator.rate_for_amount(40)).to eq(0.01)
      expect(Sequra::FeeCalculator.rate_for_amount(49.99)).to eq(0.01)
    end

    it "returns 0.95% for amounts from 50 up to 300" do
      expect(Sequra::FeeCalculator.rate_for_amount(50)).to eq(0.0095)
      expect(Sequra::FeeCalculator.rate_for_amount(60)).to eq(0.0095)
      expect(Sequra::FeeCalculator.rate_for_amount(299.99)).to eq(0.0095)
    end

    it "returns 0.85% for amounts 300 and above" do
      expect(Sequra::FeeCalculator.rate_for_amount(300)).to eq(0.0085)
      expect(Sequra::FeeCalculator.rate_for_amount(302)).to eq(0.0085)
      expect(Sequra::FeeCalculator.rate_for_amount(10_000)).to eq(0.0085)
    end

    it "returns 0 for nil or zero" do
      expect(Sequra::FeeCalculator.rate_for_amount(nil)).to eq(0)
      expect(Sequra::FeeCalculator.rate_for_amount(0)).to eq(0)
    end

    it "raises ArgumentError for negative amounts" do
      expect { Sequra::FeeCalculator.rate_for_amount(-1) }.to raise_error(ArgumentError, /cannot be negative/)
    end
  end

  describe ".commission_for_amount" do
    it "calculates correct commission for each tier" do
      expect(Sequra::FeeCalculator.commission_for_amount(10)).to eq(0.1)
      expect(Sequra::FeeCalculator.commission_for_amount(100)).to eq(0.95)
      expect(Sequra::FeeCalculator.commission_for_amount(1000)).to eq(8.5)
    end

    it "handles boundary amounts" do
      expect(Sequra::FeeCalculator.commission_for_amount(49.99)).to eq(0.5)
      expect(Sequra::FeeCalculator.commission_for_amount(50)).to eq(0.48)
      expect(Sequra::FeeCalculator.commission_for_amount(299.99)).to eq(2.85)
      expect(Sequra::FeeCalculator.commission_for_amount(300)).to eq(2.55)
    end

    it "returns 0 for nil or zero" do
      expect(Sequra::FeeCalculator.commission_for_amount(nil)).to eq(0)
      expect(Sequra::FeeCalculator.commission_for_amount(0)).to eq(0)
    end

    it "raises ArgumentError for negative amounts" do
      expect { Sequra::FeeCalculator.commission_for_amount(-1) }.to raise_error(ArgumentError, /cannot be negative/)
    end
  end

  describe ".merchant_amount_after_fee" do
    it "calculates correct merchant amount for each tier" do
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(10)).to eq(9.9)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(100)).to eq(99.05)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(1000)).to eq(991.5)
    end

    it "handles boundary amounts" do
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(49.99)).to eq(49.49)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(50)).to eq(49.53)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(299.99)).to eq(297.14)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(300)).to eq(297.45)
    end

    it "returns 0 for nil or zero" do
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(nil)).to eq(0)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(0)).to eq(0)
    end

    it "raises ArgumentError for negative amounts" do
      expect { Sequra::FeeCalculator.merchant_amount_after_fee(-1) }.to raise_error(ArgumentError, /cannot be negative/)
    end
  end
end
