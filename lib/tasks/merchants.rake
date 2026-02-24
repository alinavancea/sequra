namespace :merchants do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file_path = args[:file_path]

    if file_path.present?
      if File.exist?(file_path)
        Sequra::Import::Merchants.new(file_path).import
      else
        raise "File #{file_path} doesn't exist"
      end
    else
      raise "Needs file_path"
    end
  end
end
