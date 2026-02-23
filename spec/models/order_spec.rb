require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:merchant) { Merchant.create(
        reference: 'REF001',
        email: 'test@example.com',
        minimum_monthly_fee: 10.0,
        live_on: "2026-02-01"
      )
  }

  describe "status" do
    it "has pending, processed, failed, invalid" do
      expect(Order.statuses).to eq({ "pending" => 0, "processed" => 1, "failed" => 2, "unprocessable" => 3 })
    end

    it "creates a record with pending as default" do
      order = Order.create!(merchant: merchant, external_id: "516c2b28eceb")

      expect(order.pending?).to be true
    end

    it "creates a record with pending as default" do
      order = Order.create!(merchant: merchant, external_id: "516c2b28eceb", status: :processed)

      expect(order.processed?).to be true
    end

    it "fails when using a differnt value" do
      expect { Order.create!(merchant: merchant, external_id: "516c2b28eceb", status: :other)
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Status is not included in the list")
    end
  end

  describe "merchant" do
    it "fails with no merchant assigned" do
      expect { Order.create!(status: :pending, external_id: "516c2b28eceb")
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Merchant must exist")
    end
  end
end
