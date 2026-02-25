require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe "status" do
    it "has pending, paid, failed" do
      expect(Disbursement.statuses).to eq({ "pending" => 0, "paid" => 1, "failed" => 2 })
    end
  end

  describe "set_reference" do
    it "sets the reference automatically" do
      disbursement = create(:disbursement, reference: nil)

      expect(disbursement.reference).to eq("#{disbursement.created_at.to_date}_#{disbursement.merchant.id}")
    end
  end
end
