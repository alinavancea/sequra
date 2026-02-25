require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "status" do
    it "has pending, processed, failed, invalid" do
      expect(Order.statuses).to eq({ "pending" => 0, "processed" => 1, "failed" => 2, "unprocessable" => 3 })
    end

    it "creates a record with pending as default" do
      order = create(:order)

      expect(order.pending?).to be true
    end

    it "creates a record with processed status when set" do
      order = create(:order, status: :processed)

      expect(order.processed?).to be true
    end

    it "fails when using a different value" do
      expect {
        create(:order, status: :other)
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Status is not included in the list")
    end
  end

  describe "merchant" do
    it "fails with no merchant assigned" do
      expect {
        Order.create!(status: :pending, external_id: "516c2b28eceb")
      }.to raise_error(ActiveRecord::RecordInvalid, /Merchant must exist/)
    end
  end

  describe "amount" do
    it "fails when amount is nil" do
      expect {
        create(:order, amount: nil)
      }.to raise_error(ActiveRecord::RecordInvalid, /Amount can't be blank/)
    end

    it "fails when amount is zero" do
      expect {
        create(:order, amount: 0)
      }.to raise_error(ActiveRecord::RecordInvalid, /Amount must be greater than 0/)
    end

    it "fails when amount is negative" do
      expect {
        create(:order, amount: -10)
      }.to raise_error(ActiveRecord::RecordInvalid, /Amount must be greater than 0/)
    end
  end

  describe "order_date" do
    it "has the same date as created_at if not set" do
      order = create(:order)

      expect(order.order_date).to eq(order.created_at.to_date)
    end
  end
end
