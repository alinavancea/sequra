class Disrembursment < ApplicationRecord

  enum :status, { pending: 0, paid: 1, failed: 2}, validate: true

  validates :reference, presence: true, uniqueness: true

  has_many :orders
  belongs_to :merchant

  before_validation :set_reference, on: [:create]

  SEQURA_COMISSION_FEE = [
    { fee: 0.01, interval: 0..50 },
    { fee: 0.0095, interval: 50..300 },
    { fee: 0.0085, interval: 300 },
  ]

  def self.sequra_fee_for_ammount(amount)
    case amount
    when amount.in?(0..50)
      0.01
    when amount.in?(50..300)
      0.0095
    else
      0.0085
    end
  end

  def self.sequra_comssion_for_ammount(amount, fee)
    amount * fee
  end

  def self.merchant_ammount_after_fee(amount, fee)
    amount * (1 - fee)
  end

  private

  def set_reference
    self.reference = "#{Date.current}_#{merchant_id}"
  end
end
