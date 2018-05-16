task :travis => :environment do
  Rake::Task['test:all_the_things'].invoke
end
