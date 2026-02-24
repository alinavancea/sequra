class DisburseJob
  include Sidekiq::Job

  def perform(merchant_id, enqueue_time)
    merchant = Merchant.find(merchant_id)

    service = Sequra::Services::Disburse.new(merchant)

    service.run
  end
end
