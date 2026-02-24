namespace :disburesement do
  task enque_jobs: :environment do
    Merchant.all.each do |merchant|
      if merchant.should_disburse?
        DisburseJob.perform_async(merchant.id)
      end
    end
  end
end
