require 'rails_helper'

RSpec.describe MerchantMinimumMonthlyCommission, type: :model do
  describe "status" do
    it "has pending, paid, failed" do
      expect(Disbursement.statuses).to eq({ "pending" => 0, "paid" => 1, "failed" => 2 })
    end
  end
end
