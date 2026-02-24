require 'rails_helper'

RSpec.describe Sequra::Import::Orders do
  context "with valid data" do
    let(:file_path) { "orders.csv" }

    it "imports orders" do
      Merchant.create(reference: "padberg_group", live_on: "2022-01-01", email: "info@padberg-group.com")
      Merchant.create(reference: "bins_inc", live_on: "2022-01-01", email: "info@bins.com")

      Sequra::Import::Orders.new(file_fixture(file_path)).import

      expect(Order.count).to eq(4)
    end
  end

  context "with ivalid data" do
    let(:file_path) { "invalid_orders.csv" }

    it "imports orders" do
      Merchant.create(reference: "padberg_group", live_on: "2022-01-01", email: "info@padberg-group.com")
      Merchant.create(reference: "bins_inc", live_on: "2022-01-01", email: "info@bins.com")

      Sequra::Import::Orders.new(file_fixture(file_path)).import

      expect(Order.count).to eq(2)
    end
  end
end
