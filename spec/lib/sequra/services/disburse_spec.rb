require 'rails_helper'

RSpec.describe Sequra::Services::Disburse do
  describe "#run" do
    let(:merchant) { create(:merchant) }
    let(:service) { Sequra::Services::Disburse.new(merchant) }

    context "with pending orders" do
      before do
        create(:order, merchant: merchant, amount: 100, status: :pending)
        create(:order, merchant: merchant, amount: 10, status: :processed)
      end

      it "creates a paid disbursement with correct amounts" do
        disbursement = service.run

        expect(disbursement).to be_paid
        expect(disbursement.total_amount).to eq(100)
        expect(disbursement.sequra_commission_fee).to eq(0.0095)
        expect(disbursement.sequra_commission).to eq(0.95)
        expect(disbursement.merchant_amount).to eq(99.05)
      end

      it "marks pending orders as processed" do
        service.run

        expect(merchant.orders.processed.count).to eq(2)
        expect(merchant.orders.pending.count).to eq(0)
      end

      it "updates merchant last_disbursed_date" do
        service.run

        expect(merchant.reload.last_disbursed_date).to eq(Time.now.utc.to_date)
      end

      it "assigns the disbursement to the orders" do
        disbursement = service.run

        expect(merchant.orders.pending.count).to eq(0)
        expect(disbursement.orders.count).to eq(1)
      end
    end

    context "with no pending orders" do
      before do
        create(:order, merchant: merchant, amount: 100, status: :processed)
      end

      it "returns nil" do
        expect(service.run).to be_nil
      end

      it "does not create a disbursement" do
        service.run

        expect(Disbursement.count).to eq(0)
      end
    end

    context "when an error occurs during the transaction" do
      before do
        create(:order, merchant: merchant, amount: 100, status: :pending)
        allow_any_instance_of(Merchant).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it "rolls back the disbursement" do
        service.run

        expect(Disbursement.count).to eq(0)
      end

      it "marks pending orders as failed" do
        service.run

        expect(merchant.orders.failed.count).to eq(1)
        expect(merchant.orders.pending.count).to eq(0)
      end

      it "returns nil" do
        expect(service.run).to be_nil
      end
    end
  end
end
