FactoryBot.define do
  factory :disbursement do
    merchant
    sequence(:reference) { |n| "disbursement_#{n}" }
    status { :paid }
    total_amount { 100 }
    sequra_commission_fee { 0.0095 }
    sequra_commission { 0.95 }
    merchant_amount { 99.05 }
  end
end
