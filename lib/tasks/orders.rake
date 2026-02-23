namespace :orders do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]
    merchants = Merchant.all

    CSV.foreach(file, headers: true, col_sep: ";") do |row|
      merchant = merchants.find { |m| m.reference == row["merchant_reference"] }

      Order.find_or_create_by!(external_id: row["id"]) do |order|
        order.amount = row["amount"]
        order.created_at = row["created_at"]
        order.merchant = merchant
      end
    end
  end
end
