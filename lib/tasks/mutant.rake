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

  # As the current models are just empty shells for ActiveRecord relationships,
  # and we don't even have corresponding spec tests for those, there is no point
  # in including these in the mutation test, and thus we can save some time.
  # Only include in this collection the models that matter and have specs.
  model_classes = %w(C100Application User).freeze

  case ARGV[1]
    when nil
      # Quicker run, reduced testing scope (random sample), default option
      puts '> running quick sample mutant testing'
      BaseForm.descendants.map(&:name).grep(/^Steps::/).sample(10) +
        BaseDecisionTree.descendants.map(&:name).sample(5) +
        model_classes
    when 'all'
      # Complete coverage, very long run time
      puts '> running complete mutant testing'
      BaseForm.descendants.map(&:name).grep(/^Steps::/) + ['C100App*'] + model_classes
    else
      # Individual class testing, very quick
      Array(ARGV[1])
  end
end
