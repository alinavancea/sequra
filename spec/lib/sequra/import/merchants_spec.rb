require 'rails_helper'

RSpec.describe Sequra::Import::Merchants do
  context "with valid data" do
    let(:importer) { Sequra::Import::Merchants.new(file_fixture("merchants.csv")) }

    it "imports merchants" do
      importer.import

      expect(Merchant.count).to eq(4)
    end

    it "returns empty errors on success" do
      errors = importer.import

      expect(errors).to be_empty
    end
  end

  context "with invalid data" do
    let(:importer) { Sequra::Import::Merchants.new(file_fixture("invalid_merchants.csv")) }

    it "imports valid merchants and skips invalid ones" do
      importer.import

      expect(Merchant.count).to eq(4)
    end

    it "returns errors for invalid rows" do
      errors = importer.import

      expect(errors).not_to be_empty
    end
  end
end
