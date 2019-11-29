When(/^Using the court slugs defined in the service$/) do
  @court_slugs = C100App::CourtPostcodeChecker::COURT_SLUGS_USING_THIS_APP
  @court_aol = C100App::CourtPostcodeChecker::AREA_OF_LAW
  @court_slugs_ignore_aol = %w[
    clerkenwell-and-shoreditch-county-court-and-family-court
    salisbury-law-courts
  ]
end

Then(/^Iterate through each court slug and call the API$/) do
  @court_slugs.each do |slug|
    step %[Using the court slug "#{slug}"]
    step %[The court exists and is enabled]
    step %[I pause for "1" seconds]
  end
end

When(/^Using the court slug "([^"]*)"$/) do |slug|
  $stdout.puts "Checking court slug: #{slug}".prepend(' ' * 6)

  attributes = {
    slug: slug,
    address: nil,
    name: nil,
    email: nil
  }.stringify_keys

  @court = Court.new(attributes)
end

Then(/^The court exists and is enabled$/) do
  # We don't test here if the email is what it needs to be, as emails can change,
  # we just check if at least we found something that looks like an email address
  #
  expect(@court.best_enquiries_email).to match(/.+@.+/)

  # Above method will trigger the call to the API and populate the following
  # memoized method for further introspection (mainly for smoke tests)
  #
  expect(@court.court_data['open']).to be_truthy

  # Make an exception for these courts, acting weird, where the
  # API is returning the court despite not having `Children` in the AOL
  #
  unless @court_slugs_ignore_aol.include?(@court.slug)
    expect(@court.court_data['areas_of_law']).to include(@court_aol)
  end
end
