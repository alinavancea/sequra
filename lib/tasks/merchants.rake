namespace :merchants do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]

    CSV.foreach(file, headers: true, col_sep: ";") do |row|
      Merchant.create!(
        id: row["id"],
        reference: row["reference"],
        email: row["email"],
        live_on: row["live_on"],
        disbursement_frequency: row["disbursement_frequency"].downcase,
        minimum_monthly_fee: row["minimum_monthly_fee"].to_f
        )
    rescue => error
      p error
    end
  end
end
