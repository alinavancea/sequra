require 'rails_helper'

RSpec.describe MerchantMinimumMonthlyCommission, type: :model do
  describe "status" do
    it "has pending, processed, failed" do
      expect(MerchantMinimumMonthlyCommission.statuses).to eq({ "pending" => 0, "processed" => 1, "failed" => 2 })
    end
  end
end
