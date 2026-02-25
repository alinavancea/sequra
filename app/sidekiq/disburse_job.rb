class DisburseJob
  include Sidekiq::Job

  def perform(merchant_id)
    merchant = Merchant.find(merchant_id)

    Sequra::Services::Disburse.new(merchant).run
  end
end
