require 'rails_helper'

RSpec.describe DisburseJob, type: :job do
  let(:merchant) { create(:merchant) }

  before do
    create(:order, merchant: merchant, amount: 100, status: :pending)
  end

  it "creates a disbursement for the merchant" do
    DisburseJob.new.perform(merchant.id)

    expect(Disbursement.count).to eq(1)
    expect(Disbursement.last.merchant).to eq(merchant)
  end

  it "processes pending orders" do
    DisburseJob.new.perform(merchant.id)

    expect(merchant.orders.pending.count).to eq(0)
    expect(merchant.orders.processed.count).to eq(1)
  end

  it "raises ActiveRecord::RecordNotFound for invalid merchant_id" do
    expect {
      DisburseJob.new.perform("non-existent-id")
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
