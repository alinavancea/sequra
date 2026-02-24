class Merchant < ApplicationRecord
  enum :disbursement_frequency, { daily: 0, weekly: 1 }, validate: true

  validates :reference, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :disbursement_frequency, presence: true
  validates :live_on, presence: true
  validates :minimum_monthly_fee,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  before_validation :normalize_reference, :normalize_disbursement_frequency, on: [ :create ]

  has_many :orders
  has_many :disbursements
  has_many :merchant_minimum_monthly_commissions

  # TODO: Add test for this, method refactored with claude
  def should_disburse?
    pending_orders? && !already_disbursed? && correct_frequency_day?
  end

  def live_on_weekday
    live_on.wday
  end

  def paid_disbursements_for(interval)
    disbursements.paid.for_interval
  end

  private

  def pending_orders?
    orders.pending.any?
  end

  def already_disbursed?
    paid_disbursements_for(disbursement_time_interval).any?
  end

  def correct_frequency_day?
    return true if daily?
    Time.now.utc.wday == live_on_weekday
  end

  def disbursement_time_interval
    today = Time.now.utc
    if weekly?
      today.last_week.beginning_of_day..today.end_of_day
    else
      today.beginning_of_day..today.end_of_day
    end
  end

  def normalize_reference
    self.reference = reference&.downcase&.gsub(/[' ]/, "'" => "_", " " => "_", "-" => "_")
  end

  def normalize_disbursement_frequency
    self.disbursement_frequency = disbursement_frequency.downcase
  end
end
