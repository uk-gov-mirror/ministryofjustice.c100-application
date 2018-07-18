task :travis => :environment do
  Rake::Task['test:all_the_things_since_master'].invoke
end
