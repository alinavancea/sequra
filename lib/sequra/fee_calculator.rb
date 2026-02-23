module Sequra
  class FeeCalculator
    SEQURA_COMISSION_FEE = [
      { fee: 0.01, interval: 0..50 },
      { fee: 0.0095, interval: 50..300 },
      { fee: 0.0085, interval: 300 }
    ]

    # TODO:
    # Use the constant here
    def self.for_ammount(amount)
      case amount
      when amount.in?(0..50)
        0.01
      when amount.in?(50..300)
        0.0095
      else
        0.0085
      end
    end

    def self.comssion_for_ammount(amount, fee)
      amount * fee
    end

    def self.merchant_ammount_after_fee(amount, fee)
      amount * (1 - fee)
    end
  end
end
