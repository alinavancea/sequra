module Sequra
  class FeeCalculator
    COMMISSION_FEES = [
      { range: (0...50), rate: 0.01 },
      { range: (50...300), rate: 0.0095 },
      { range: (300...), rate: 0.0085 }
    ].freeze

    def self.for_amount(amount)
      return 0 if amount.nil? || amount == 0

      COMMISSION_FEES.find { |fee| fee[:range].cover?(amount) }&.dig(:rate) || 0
    end

    def self.commission_for_amount(amount)
      return 0 if amount.nil? || amount <= 0

      (amount * for_amount(amount)).round(2)
    end

    def self.merchant_amount_after_fee(amount)
      return 0 if amount.nil? || amount <= 0

      (amount * (1 - for_amount(amount))).round(2)
    end
  end
end
