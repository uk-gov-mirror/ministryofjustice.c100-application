task :cucumber => :environment do
  vars = 'RAILS_ENV=test NOCOVERAGE=true'

  unless system("bundle exec cucumber")
    raise 'Cucumber testing failed'
  end

end
