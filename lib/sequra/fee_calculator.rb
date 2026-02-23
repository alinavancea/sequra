module Sequra
  class FeeCalculator
    SEQURA_COMISSION_FEE = [
      { fee: 0.01, interval: (0...50) },
      { fee: 0.0095, interval: (50...300) },
      { fee: 0.0085, interval: (300...) }
    ]

    # TODO:
    # Use the constant here
    def self.for_amount(amount)
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

    def self.comssion_for_amount(amount, fee)
      amount * fee
    end

    def self.merchant_amount_after_fee(amount, fee)
      amount * (1 - fee)
    end
  end
end
