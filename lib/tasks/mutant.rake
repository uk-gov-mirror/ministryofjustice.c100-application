# Pass a match expression as an optional argument to only run mutant
# on classes that match. Example: `rake mutant TaxTribs::ZendeskSender`
#
task :mutant => :environment do
  mutation_type = ARGV[1]

  vars = 'RAILS_ENV=test NOCOVERAGE=true'
  flags = '--use rspec --fail-fast'
  source_ref = 'origin/master'

  # This is to avoid running the mutant with flag `--since master` when
  # we are already on master, as otherwise it will not work on CI.
  #
  # For now we support both, CircleCI and Travis, but soon we will only use one.
  if ENV['CIRCLECI']
    current_branch = ENV['CIRCLE_BRANCH'] || `git rev-parse --abbrev-ref HEAD`
  else
    current_branch = ENV['TRAVIS_BRANCH'] || `git rev-parse --abbrev-ref HEAD`
    current_branch = ENV['TRAVIS_PULL_REQUEST_BRANCH'] if ENV.fetch('TRAVIS_PULL_REQUEST', 'false') != 'false'
  end

  if mutation_type == 'master'
    puts "> current branch: #{current_branch}"

    if current_branch != 'master'
      puts "> running complete mutant testing on all changes since #{source_ref}"
      flags.prepend("--since #{source_ref} ")
    else
      # As we are already in master, let's not use the --since, and fallback to
      # running the quick randomised sample
      puts "> already on master, overriding --since flag"
      mutation_type = nil
    end
  end

  unless system("#{vars} mutant #{flags} #{classes_to_mutate(mutation_type).join(' ')}")
    raise 'Mutation testing failed'
  end

  exit
end

private

def classes_to_mutate(option)
  Rails.application.eager_load!

  case option
    when nil
      # Quicker run, reduced testing scope (random sample), default option
      puts '> running quick sample mutant testing'
      form_objects.sample(5) + decision_trees_and_services.sample(3) + models
    when 'all', 'master'
      # Complete coverage (very long run time) or only changed classes
      puts '> running complete mutant testing'
      form_objects + decision_trees_and_services + models
    else
      # Individual class testing, very quick
      # we'll take all arguments after the first (which is 'mutant')
      _foo, *classes = ARGV
      classes
  end
end

# As the current models are just empty shells for ActiveRecord relationships,
# and we don't even have corresponding spec tests for those, there is no point
# in including these in the mutation test, and thus we can save some time.
# Only include in this collection the models that matter and have specs.
#
def models
  %w(
    C100Application
    User
    Court
    CompletedApplicationsAudit
    ShortUrl
  ).freeze
end

# Everything inheriting from `BaseForm` and inside namespace `Steps`
# i.e. all classes in `/app/forms/steps/**/*`
#
def form_objects
  BaseForm.descendants.map(&:name).grep(/^Steps::/)
end

# Everything inside `C100App` namespace
# i.e. all classes in `/app/services/c100_app/*`
#
def decision_trees_and_services
  C100App.constants.map { |symbol| C100App.const_get(symbol) }
end
