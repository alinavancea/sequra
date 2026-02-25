FactoryBot.define do
  factory :merchant do
    sequence(:reference) { |n| "merchant_#{n}" }
    sequence(:email) { |n| "merchant#{n}@example.com" }
    disbursement_frequency { :daily }
    minimum_monthly_fee { 10.0 }
    live_on { "2022-01-01" }

    trait :weekly do
      disbursement_frequency { :weekly }
    end
  end
end
