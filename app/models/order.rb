class Order < ApplicationRecord
  enum :status, { pending: 0, processed: 1, failed: 2, unprocessable: 3 }, validate: true

  belongs_to :merchant
end
