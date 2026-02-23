module Sequra
  class FeeCalculator
    # TODO:
    # Use a constant
    def self.for_amount(amount)
      return 0 if amount.nil? || amount == 0

      case amount
      when (0...50)
        0.01
      when (50...300)
        0.0095
      when (300...)
        0.0085
      else
        0
      end
    end

    def self.comssion_for_amount(amount)
      return 0 if amount.nil? || amount <= 0

      (amount * for_amount(amount)).round(2)
    end

    def self.merchant_amount_after_fee(amount)
      return 0 if amount.nil? || amount <= 0

      (amount * (1 - for_amount(amount))).round(2)
    end
  end
end
