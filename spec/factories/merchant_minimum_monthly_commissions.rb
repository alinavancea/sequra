FactoryBot.define do
  factory :merchant_minimum_monthly_commission do
    merchant
    minimum_monthly_comission { 10.0 }
    commission_date { Date.current }
    status { :pending }
  end
end
