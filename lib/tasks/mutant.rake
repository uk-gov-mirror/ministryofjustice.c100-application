# Pass a match expression as an optional argument to only run mutant
# on classes that match. Example: `rake mutant TaxTribs::ZendeskSender`
#
task :mutant => :environment do
  vars = 'NOCOVERAGE=true'
  flags = '--use rspec --fail-fast'

  classes_to_mutate.each do |klass|
    unless system("#{vars} mutant #{flags} #{klass}")
      raise 'Mutation testing failed'
    end
  end

  exit
end

task(:default).prerequisites << task(:mutant)

private

def classes_to_mutate
  Rails.application.eager_load!
  Array(ARGV[1]).presence ||
    ApplicationRecord.descendants.map(&:name) +
    BaseForm.descendants.map(&:name).grep(/^Steps::/) +
    ['C100App*']
end
