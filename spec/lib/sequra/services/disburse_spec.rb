require 'rails_helper'

RSpec.describe Sequra::Services::Disburse do
  describe "run" do
    let(:merchant1) { Merchant.create(reference: "padberg_group", live_on: "2022-01-01", email: "info@padberg-group.com", disbursement_frequency: :daily) }
    let(:merchant2) { Merchant.create(reference: "bins_inc", live_on: "2022-01-01", email: "info@bins.com", disbursement_frequency: :daily) }
    let(:merchant3) { Merchant.create(reference: "weeekly_bins_inc", live_on: "2022-01-01", email: "info@bins.com", disbursement_frequency: :weekly) }

    let(:service1) { Sequra::Services::Disburse.new(merchant1) }
    let(:service2) { Sequra::Services::Disburse.new(merchant2) }
    let(:service3) { Sequra::Services::Disburse.new(merchant3) }

    before do
      Order.create(merchant: merchant1, external_id: "516c2b28eceb1", amount: 100, status: :pending)
      Order.create(merchant: merchant1, external_id: "516c2b28eceb2", amount: 10, status: :processed)
      Order.create(merchant: merchant2, external_id: "516c2b28eceb3", amount: 9, status: :pending)
      Order.create(merchant: merchant2, external_id: "516c2b28eceb4", amount: 91, status: :unprocessable)
      Order.create(merchant: merchant3, external_id: "516c2b28eceb4", amount: 91, status: :pending)
    end

    describe "pending orders" do
      it "has pending orders" do
        expect(service1.pending_orders.count).to eq(1)
        expect(service2.pending_orders.count).to eq(1)
        expect(service3.pending_orders.count).to eq(1)
      end
    end

    describe "disburse" do
      it "works" do
        disbursement = service1.run

        expect(Disbursement.count).to eq(1)

        expect(disbursement.merchant_amount).to eq(99.05)
        expect(disbursement.sequra_commission_fee).to eq(0.0095)
        expect(disbursement.sequra_commission).to eq(0.95)
        expect(disbursement.total_amount).to eq(100)
        expect(disbursement).to be_paid
      end
    end
  end
end
