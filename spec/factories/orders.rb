FactoryBot.define do
  factory :order do
    merchant
    sequence(:external_id) { |n| "order_#{n}" }
    amount { 100 }
    status { :pending }
  end
end
