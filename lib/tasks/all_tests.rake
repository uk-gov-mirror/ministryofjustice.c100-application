namespace :test do
  # test:all is already defined by rails
  task all_the_things: :environment do
    Rake::Task['rubocop'].invoke
    Rake::Task['brakeman'].invoke
    Rake::Task['spec'].invoke
    Rake::Task['cucumber'].invoke
    Rake::Task['mutant'].invoke
  end
end

if %w(development test).include? Rails.env
  task(:default).prerequisites << task('test:all_the_things')
end
