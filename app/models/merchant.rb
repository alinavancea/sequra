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

  private

  def normalize_reference
    self.reference = reference&.downcase&.gsub(/[' ]/, "'" => "_", " " => "_", "-" => "_")
  end

  def normalize_disbursement_frequency
    self.disbursement_frequency = disbursement_frequency.downcase
  end
end
