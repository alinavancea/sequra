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

  # TODO: test this
  def should_disburse?
    # has any pending orders
    # has no disbursements
    # weekly and today is the weekday from live_on
    today = Time.now.utc
    wday_for_today = today.wday

    if self.weekly?
      time_interval = today.last_week.beginning_of_day .. today.end_of_day

      wday_for_today == live_on_weekday && orders.pending.any? && paid_disbursements_for(time_interval).empty?
    else
      time_interval = today.beginning_of_day .. today.end_of_day

      orders.pending.any? && paid_disbursements_for(time_interval).empty?
    end
  end

  def live_on_weekday
    live_on.wday
  end

  def paid_disbursements_for(interval)
    disbursements.paid.for_interval
  end

  private

  def normalize_reference
    self.reference = reference&.downcase&.gsub(/[' ]/, "'" => "_", " " => "_", "-" => "_")
  end

  def normalize_disbursement_frequency
    self.disbursement_frequency = disbursement_frequency.downcase
  end
end
