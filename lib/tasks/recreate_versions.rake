namespace :loft do
  desc "Recreate Loft asset versions"
  task :recreate_versions => :environment do
    ::Asset.all.to_a.each do |a|
      begin
        a.file.recreate_versions!
      rescue Errno::ENOENT
        puts "Skip #{a._number}: source file not found"
      end
    end
  end
end
