require 'rails_helper'

RSpec.describe Sequra::Services::Disburse do
  describe "run" do
    let(:merchant1) { Merchant.create(reference: "padberg_group", live_on: "2022-01-01", email: "info@padberg-group.com", disbursement_frequency: :daily) }
    let(:merchant2) { Merchant.create(reference: "bins_inc", live_on: "2022-01-01", email: "info@bins.com", disbursement_frequency: :daily) }
    let(:merchant3) { Merchant.create(reference: "weeekly_bins_inc", live_on: "2022-01-01", email: "info@bins.com", disbursement_frequency: :weekly) }

    context "for daily merchants" do
      let(:daily_service) { Sequra::Services::Disburse.new(:daily) }

      it "disburese the orders" do
        m1_pending_order = Order.create(merchant: merchant1, external_id: "516c2b28eceb1", amount: 100, status: :pending)
        processed_order = Order.create(merchant: merchant1, external_id: "516c2b28eceb2", amount: 10, status: :processed)
        m2_pending_order = Order.create(merchant: merchant2, external_id: "516c2b28eceb3", amount: 9, status: :pending)
        unprocessable_order = Order.create(merchant: merchant2, external_id: "516c2b28eceb4", amount: 91, status: :unprocessable)
        weekly_order = Order.create(merchant: merchant3, external_id: "516c2b28eceb4", amount: 91, status: :pending)

        daily_service.run

        expect(Disbursement.count).to eq(2)

        m1_disbursement = m1_pending_order.reload.disbursement
        m2_disbursement = m2_pending_order.reload.disbursement

        expect(m1_disbursement.merchant_amount).to eq(99.05)
        expect(m1_disbursement.sequra_commission_fee).to eq(0.0095)
        expect(m1_disbursement.sequra_commission).to eq(0.95)
        expect(m1_disbursement.total_amount).to eq(100)
        expect(m1_disbursement).to be_paid

        expect(m2_disbursement.merchant_amount).to eq(8.91)
        expect(m2_disbursement.sequra_commission_fee).to eq(0.01)
        expect(m2_disbursement.sequra_commission).to eq(0.09)
        expect(m2_disbursement.total_amount).to eq(9)
        expect(m2_disbursement).to be_paid

        expect(m1_pending_order.reload).to be_processed
        expect(m2_pending_order.reload).to be_processed
      end
    end

    context "for weekly merchants" do
      let(:weekly_service) { Sequra::Services::Disburse.new(:weekly) }

      it "disburese the orders" do
        m1_pending_order = Order.create(merchant: merchant1, external_id: "516c2b28eceb1", amount: 100, status: :pending)
        processed_order = Order.create(merchant: merchant1, external_id: "516c2b28eceb2", amount: 10, status: :processed)
        m2_pending_order = Order.create(merchant: merchant2, external_id: "516c2b28eceb3", amount: 9, status: :pending)
        unprocessable_order = Order.create(merchant: merchant2, external_id: "516c2b28eceb4", amount: 91, status: :unprocessable)
        weekly_order = Order.create(merchant: merchant3, external_id: "516c2b28eceb4", amount: 91, status: :pending)

        weekly_service.run

        expect(Disbursement.count).to eq(1)

        m3_disbursement = weekly_order.reload.disbursement

        expect(m3_disbursement.merchant_amount).to eq(90.14)
        expect(m3_disbursement.sequra_commission_fee).to eq(0.0095)
        expect(m3_disbursement.sequra_commission).to eq(0.86)
        expect(m3_disbursement.total_amount).to eq(91)
        expect(m3_disbursement).to be_paid

        expect(weekly_order.reload).to be_processed
      end
    end
  end
end
