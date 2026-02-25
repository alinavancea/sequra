require "bigdecimal"

module Sequra
  class FeeCalculator
    COMMISSION_FEES = [
      { range: (0...50), rate: BigDecimal("0.01") },
      { range: (50...300), rate: BigDecimal("0.0095") },
      { range: (300...), rate: BigDecimal("0.0085") }
    ].freeze

    def self.rate_for_amount(amount)
      validate_amount!(amount)
      return 0 if amount.nil? || amount == 0

      COMMISSION_FEES.find { |fee| fee[:range].cover?(amount) }&.dig(:rate) || 0
    end

    def self.commission_for_amount(amount)
      validate_amount!(amount)
      return 0 if amount.nil? || amount == 0

      (amount * rate_for_amount(amount)).round(2)
    end

    def self.merchant_amount_after_fee(amount)
      validate_amount!(amount)
      return 0 if amount.nil? || amount == 0

      (amount * (1 - rate_for_amount(amount))).round(2)
    end

    def self.validate_amount!(amount)
      raise ArgumentError, "Amount cannot be negative: #{amount}" if amount.is_a?(Numeric) && amount < 0
    end

    private_class_method :validate_amount!
  end
end
