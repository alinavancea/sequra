namespace :merchants do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]

    CSV.foreach(file, headers: true, col_sep: ";") do |row|
      Merchant.find_or_create_by!(reference: row["reference"]) do |merchant|
        merchant.id = row["id"]
        merchant.email = row["email"]
        merchant.live_on = row["live_on"]
        merchant.disbursement_frequency = row["disbursement_frequency"]
        merchant.minimum_monthly_fee = row["minimum_monthly_fee"].to_f
      rescue => error
        p error
      end
    end
  end
end
