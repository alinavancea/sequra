namespace :minimum_monthly_fee do
  task calculate_and_store: :environment do
    desc "Calculates and stores the minimum monthly fees"
    # Every first day of the month

    first_day_of_last_month = Time.now.utc.beginning_of_month.last_month
    last_day_of_last_month = first_day_of_last_month.at_end_of_month
    last_month_interval = first_day_of_last_month .. last_day_of_last_month

    Sequra::Services::MinimumMonthlyFees.new.calculate(last_month_interval)
  end
end
