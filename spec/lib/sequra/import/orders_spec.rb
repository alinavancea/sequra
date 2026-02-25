require 'rails_helper'

RSpec.describe Sequra::Import::Orders do
  let!(:padberg) { create(:merchant, reference: "padberg_group") }
  let!(:bins) { create(:merchant, reference: "bins_inc") }

  context "with valid data" do
    let(:importer) { Sequra::Import::Orders.new(file_fixture("orders.csv")) }

    it "imports all orders" do
      importer.import

      expect(Order.count).to eq(4)
    end

    it "assigns orders to the correct merchants" do
      importer.import

      expect(padberg.orders.count).to eq(2)
      expect(bins.orders.count).to eq(2)
    end

    it "sets the correct amount and order_date" do
      importer.import

      order = Order.find_by(external_id: "e653f3e14bc4")

      expect(order.amount).to eq(102.29)
      expect(order.order_date).to eq(Date.parse("2023-02-01"))
      expect(order.merchant).to eq(padberg)
    end

    it "does not create duplicates on re-import" do
      2.times { importer.import }

      expect(Order.count).to eq(4)
    end

    it "returns empty errors on success" do
      errors = importer.import

      expect(errors).to be_empty
    end
  end

  context "with invalid data" do
    let(:importer) { Sequra::Import::Orders.new(file_fixture("invalid_orders.csv")) }

    it "imports only valid orders" do
      importer.import

      expect(Order.count).to eq(2)
    end

    it "skips rows with missing merchant reference" do
      importer.import

      expect(Order.find_by(external_id: "e653f3e14bc4")).to be_nil
    end

    it "skips rows with missing external_id" do
      importer.import

      expect(Order.where(amount: 433.21).count).to eq(0)
    end

    it "returns errors for invalid rows" do
      errors = importer.import

      expect(errors.length).to eq(2)
    end
  end
end
