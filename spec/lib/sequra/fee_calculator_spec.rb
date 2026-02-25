require 'rails_helper'

RSpec.describe Sequra::FeeCalculator do
  describe "fees" do
    it "returns correct fees" do
      expect(Sequra::FeeCalculator.for_amount(40)).to eq(0.01)
      expect(Sequra::FeeCalculator.for_amount(50)).to eq(0.0095)
      expect(Sequra::FeeCalculator.for_amount(60)).to eq(0.0095)
      expect(Sequra::FeeCalculator.for_amount(300)).to eq(0.0085)
      expect(Sequra::FeeCalculator.for_amount(302)).to eq(0.0085)

      expect(Sequra::FeeCalculator.for_amount(0)).to eq(0)
      expect(Sequra::FeeCalculator.for_amount(-1)).to eq(0)
    end

    it "calculates correct comission" do
      expect(Sequra::FeeCalculator.commission_for_amount(10)).to eq(0.1)
      expect(Sequra::FeeCalculator.commission_for_amount(100)).to eq(0.95)
      expect(Sequra::FeeCalculator.commission_for_amount(1000)).to eq(8.5)

      expect(Sequra::FeeCalculator.commission_for_amount(0)).to eq(0)
      expect(Sequra::FeeCalculator.commission_for_amount(-1)).to eq(0)
    end

    it "calculates correct merchant amount after fee" do
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(10)).to eq(9.9)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(100)).to eq(99.05)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(1000)).to eq(991.5)

      expect(Sequra::FeeCalculator.merchant_amount_after_fee(0)).to eq(0)
      expect(Sequra::FeeCalculator.merchant_amount_after_fee(-1)).to eq(0)
    end
  end
end
