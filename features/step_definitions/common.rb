include ActiveSupport::Testing::TimeHelpers

# General and frequently used navigation steps, handling of links and page expectations
#
When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect("#{Capybara.app_host}#{URI.parse(current_url).path}").to eql("#{Capybara.app_host}#{page_name}")
end

Then(/^I should see "([^"]*)"$/) do |text|
  find(:xpath, './/main', visible: true, wait: true)
  expect(page).to have_text(text)

rescue Selenium::WebDriver::Error::UnknownError => e
  find(:xpath, './/main', visible: true, wait: true)
  expect(page).to have_text(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_text(text)
end

Then(/^I should see a "([^"]*)" link to "([^"]*)"$/) do |text, href|
  find(:xpath, './/main', visible: true, wait: true)
  expect(page).to have_link(text, href: href)
rescue Selenium::WebDriver::Error::UnknownError => e
  find(:xpath, './/main', visible: true, wait: true)
  expect(page).to have_link(text, href: href)
end

Then(/^I should see the save draft button$/) do
  expect(page).to have_selector(:button, 'Save and come back later')
end

Then(/^I should not see the save draft button$/) do
  expect(page).not_to have_selector(:button, 'Save and come back later')
end

When(/^I click the "([^"]*)" link$/) do |text|
  find(:xpath, './/main', visible: true, wait: true)
  find(:css, 'a', text: text).click
rescue Selenium::WebDriver::Error::UnknownError => e
  find(:xpath, './/main', visible: true, wait: true)
  click_link(text)
end

When(/^I open the "([^"]*)" summary details$/) do |text|
  find('details > summary > span', text: text).click
end

When(/^I click the "([^"]*)" button$/) do |text|
  expect(page).to have_button("#{text}")
  find_button("#{text}").click
rescue Selenium::WebDriver::Error::UnknownError => e
  find_button("#{text}").click
end

When(/^I wait and click the "([^"]*)" button$/) do |text|
  travel_to 61.minutes.from_now
  begin
    find_button("#{text}").click
  rescue
    click_link(text)
  end
end

Then('the time goes back to normal') do
  travel_back
end

When(/^I click the postcode page "([^"]*)" button$/) do |text|
  RSpec::Mocks.with_temporary_scope do
    stub_courtfinder_api
    original_path = current_path
    find_button("#{text}").click
    expect(page).to_not have_current_path(original_path)
  end
end

When(/^I wait and click the postcode page "([^"]*)" button$/) do |text|
  travel 61.minutes do
    RSpec::Mocks.with_temporary_scope do
      stub_courtfinder_api
      original_path = current_path
      begin
        find_button("#{text}").click
      rescue
        click_link(text)
      end
      expect(page).to_not have_current_path(original_path)
    end
  end
end

When(/^I click the postcode page "([^"]*)" button with an invalid postcode$/) do |text|
  RSpec::Mocks.with_temporary_scope do
    C100App::NewCourtfinderApi.any_instance.stub(:court_for).and_return({"courts"=>[]})

    find_button("#{text}").click
    expect(page).to have_current_path('/steps/opening/no_court_found')
  end
end

When(/^I have started an application$/) do
  step %[I visit "/"]
  step %[I open the "Developer Tools" summary details]
  find('button', text: 'Bypass postcode').click
  expect(page).to have_current_path("/steps/opening/consent_order")
end

When(/^I am on the home page$/) do
  step %[I visit "/"]
end

When(/^I pause for "([^"]*)" seconds$/) do |seconds|
  sleep seconds.to_i
end

And(/^Page has title "([^"]*)"/) do |text|
  expect(page).to have_title(text)
end

Given("I stub fact api call") do
  WebMock.enable!
  WebMock.allow_net_connect!
  WebMock::API.stub_request(:get, "https://www.find-court-tribunal.service.gov.uk/v2/proxy/search/postcode/TQ121XX/serviceArea/childcare-arrangements").
    to_return(status: 200, body: "{}", headers: {})

  WebMock::API.stub_request(:get, "https://www.find-court-tribunal.service.gov.uk/health").
    to_return(status: 200, body: "{\"mapit-api\":{\"status\":\"UP\"}}", headers: {})
end

And(/^I wait for (\d+) minutes$/) do |arg|
  travel arg.minutes
end

Given(/^I have completed an application$/) do
  step %[I visit "/"]
  step %[I open the "Developer Tools" summary details]
  find('button', text: 'Bypass to CYA', exact_text: true).click
end

When(/^I start the application$/) do
  find("a[href='/steps/opening/postcode']").click
end

When(/^I fill in a postcode for the children$/) do
  fill_in('steps_opening_postcode_form[children_postcode]', with: 'MK9 3DX')
end

When(/^I fill in a postcode "([^"]*)" for the children$/) do |arg|
  fill_in('steps_opening_postcode_form[children_postcode]', with: arg)
end

When('court finder raises an error') do
  courtfinder_mock = instance_double(C100App::NewCourtfinderApi, is_ok?: false)
  allow(C100App::NewCourtfinderApi).to receive(:new).and_return(courtfinder_mock)
  allow(courtfinder_mock).to receive(:court_for).and_raise(StandardError.new('Courtfinder API error'))
end

Given('stub court finder responses') do
  courtfinder_mock = instance_double(C100App::NewCourtfinderApi, is_ok?: false)
  allow(C100App::NewCourtfinderApi).to receive(:new).and_return(courtfinder_mock)
end

Given('debugger') do
  binding.pry
  :a
end

When('I navigate to the Safety concerns from consent order page') do
  consent_order_page.submit_without_consent_order
  child_protection_case_page.submit_yes
  expect(miam_page.content).to have_text('You do not have to attend a MIAM')

  miam_page.click_continue_link
  expect(safety_concern_page.content).to have_header
end

When('I let session to expire') do
  travel_to 61.minutes.from_now do
    # save_and_open_page
    expect(page).to have_text("Sorry, you'll have to start again")
  end
end

When('I navigate to applicant names page from consent order') do
  consent_order_page.submit_without_consent_order
  child_protection_case_page.submit_yes
  expect(miam_page.content).to have_text('You do not have to attend a MIAM')

  miam_page.click_continue_link
  expect(safety_concern_page.content).to have_header

  safety_concern_page.click_continue_link
  # Navigate through safety questions to get to applicant names
  # This is a simplified path - in reality may need more steps
end

When('I complete the applicant details journey') do
  # Navigate to applicant names
  applicant_names_page.submit_names('John', 'Doe Senior')

  # Privacy questions
  applicant_privacy_known_page.submit_yes
  applicant_privacy_preferences_page.submit_no
  applicant_refuge_page.submit_no
  applicant_privacy_summary_page.click_continue_link

  # Personal details
  applicant_personal_details_page.submit_personal_details(
    has_previous_name: 'no',
    gender: 'male',
    age: 26,
    birthplace: 'Manchester'
  )

  # Relationship
  applicant_relationship_page.submit_relationship('Father')

  # Address
  address_lookup_page.click_outside_uk
  applicant_address_details_page.submit_address_details(
    address_line_1: 'Test street',
    town: 'London',
    country: 'United Kingdom',
    residence_5_years: 'yes'
  )

  # Contact details
  applicant_contact_details_page.submit_contact_details(
    email: 'john@email.com',
    phone: '00000000000',
    voicemail_consent: 'yes'
  )
end
