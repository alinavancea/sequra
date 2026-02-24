class Disbursement < ApplicationRecord
  enum :status, { pending: 0, paid: 1, failed: 2 }, validate: true

  validates :reference, presence: true, uniqueness: true

  has_many :orders
  belongs_to :merchant

  before_validation :set_reference, on: [ :create ]

  private

  def set_reference
    self.reference = "#{Date.current}_#{merchant_id}" unless reference.present?
  end
end
