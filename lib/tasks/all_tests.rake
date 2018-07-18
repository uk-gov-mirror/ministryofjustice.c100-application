
namespace :test do
  task all_standard_tests: :environment do
    Rake::Task['rubocop'].invoke
    Rake::Task['spec'].invoke
    Rake::Task['brakeman'].invoke
    Rake::Task['cucumber'].invoke
  end

  # test:all is already defined by rails
  task all_the_things: :all_standard_tests do
    Rake::Task['mutant'].invoke
  end

  task all_the_things_since_master: :all_standard_tests do
    Rake::Task['mutant_since_master'].invoke
  end
end


if %w(development test).include? Rails.env
  task(:default).prerequisites << task('test:all_the_things')
end
