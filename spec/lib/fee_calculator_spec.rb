require 'rails_helper'

RSpec.describe Sequra::FeeCalculator do
  describe "fees" do
    it "returns correct fees" do
      expect(Sequra::FeeCalculator.for_amount(40)).to eq(0.01)
      expect(Sequra::FeeCalculator.for_amount(50)).to eq(0.0095)
      expect(Sequra::FeeCalculator.for_amount(60)).to eq(0.0095)
      expect(Sequra::FeeCalculator.for_amount(300)).to eq(0.0085)
      expect(Sequra::FeeCalculator.for_amount(302)).to eq(0.0085)
    end
  end
end
