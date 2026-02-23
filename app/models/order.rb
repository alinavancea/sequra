class Order < ApplicationRecord
  enum :status, { pending: 0, processed: 1, failed: 2, unprocessable: 3 }, validate: true

  validates :external_id, presence: true
  belongs_to :merchant
  belongs_to :disbursement, optional: true
end
