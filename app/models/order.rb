class Order < ApplicationRecord
  enum :status, { pending: 0, processed: 1, failed: 2, unprocessable: 3 }, validate: true

  validates :external_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  belongs_to :merchant
  belongs_to :disbursement, optional: true
end
