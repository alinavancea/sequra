class MerchantMinimumMonthlyCommission < ApplicationRecord
  enum :status, { pending: 0, processed: 1, failed: 2 }, validate: true

  validates :minimum_monthly_comission, presence: true
  validates :commission_date, presence: true, uniqueness: { scope: [ :merchant_id ] }

  belongs_to :merchant
end
