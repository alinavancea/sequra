require 'rails_helper'

RSpec.describe Sequra::Services::Disburse do
  describe "run" do
    let(:merchant1) { create(:merchant, reference: "padberg_group", email: "info@padberg-group.com") }
    let(:merchant2) { create(:merchant, reference: "bins_inc", email: "info@bins.com") }
    let(:merchant3) { create(:merchant, :weekly, reference: "weekly_bins_inc", email: "info@wbins.com") }

    let(:service1) { Sequra::Services::Disburse.new(merchant1) }
    let(:service2) { Sequra::Services::Disburse.new(merchant2) }
    let(:service3) { Sequra::Services::Disburse.new(merchant3) }

    before do
      create(:order, merchant: merchant1, amount: 100, status: :pending)
      create(:order, merchant: merchant1, amount: 10, status: :processed)
      create(:order, merchant: merchant2, amount: 9, status: :pending)
      create(:order, merchant: merchant2, amount: 91, status: :unprocessable)
      create(:order, merchant: merchant3, amount: 91, status: :pending)
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
