namespace :orders do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]

    if file_path.present?
      if File.exist?(file_path)
        Sequra::Import::Orders.new(file).import
      else
        raise "File #{file_path} doesn't exist"
      end
    else
      raise "Needs file_path"
    end
  end

  task :disburse, [ :disbursement_frequence ] => [ :environment ] do |t, args|
    frequence = args[:disbursement_frequence]

    raise "Invalid frequence, should be daily or weekly" unless frequence.in?([ "daily", "weekly" ])
    Sequra::Services::Disburse.new(frequence).run
  end
end
