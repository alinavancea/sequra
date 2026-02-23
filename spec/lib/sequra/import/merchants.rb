require 'rails_helper'

RSpec.describe Sequra::Import::Merchants do
  context "with valid data" do
    let(:file_path) { "merchants.csv" }

    it "imports merchants" do
      Sequra::Import::Merchants.new(file_fixture(file_path)).import

      expect(Merchant.count).to eq(4)
    end
  end

  context "with ivalid data" do
    let(:file_path) { "invalid_merchants.csv" }

    it "imports merchants" do
      Sequra::Import::Merchants.new(file_fixture(file_path)).import

      expect(Merchant.count).to eq(4)
    end
  end
end
