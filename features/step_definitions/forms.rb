# Everything that has to do with forms, like radios, check boxes or inputs
#
When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

And(/^I check "([^"]*)"$/) do |text|
  check(text, allow_label_click: true)
end

When(/^I click the radio button "([^"]*)"$/) do |text|
  find('label', text: text).click
end

Then(/^I click "([^"]*)" for the radio button "([^"]*)"$/) do |text, legend|
  find(
    'legend > span', text: legend
  ).ancestor(
    'fieldset', order: :reverse, match: :first
  ).find(
    'label', text: text
  ).click
end

When(/^I choose "([^"]*)"$/) do |text|
  step %[I click the radio button "#{text}"]
  find('[name=commit]').click
end

And(/^I choose "([^"]*)" and fill in "([^"]*)" with "([^"]*)"$/) do |text, field, value|
  step %[I click the radio button "#{text}"]
  step %[I fill in "#{field}" with "#{value}"]
  find('[name=commit]').click
end

When(/^I enter the date (\d+)\-(\d+)\-(\d+)$/) do |day, month, year|
  step %[I fill in "Day" with "#{day}"]
  step %[I fill in "Month" with "#{month}"]
  step %[I fill in "Year" with "#{year}"]
end

# For MIAM the date must not be older than 4 months
And(/^I enter a valid MIAM date$/) do
  step %[I enter the date #{Date.yesterday.strftime("%d-%m-%Y")}]
  step %[I click the "Continue" button]
end

# For children sub form on safety concerns
Then(/^I submit the form details for "([^"]*)"$/) do |heading|
  step %[I should see "#{heading}"]
  step %[I fill in "Briefly describe what happened and who was involved, if you feel able to" with "Information..."]

  step %[I fill in "When did this behaviour start?" with "2 weeks ago"]

  step %[I click "No" for the radio button "Is the behaviour still ongoing?"]
  step %[I fill in "When did the behaviour stop?" with "1 weeks ago"]

  step %[I click "Yes" for the radio button "Have you ever asked for help?"]
  step %[I fill in "Who did you ask for help?" with "Friend"]

  step %[I click "Yes" for the radio button "Did they help you?"]
  step %[I fill in "What did they do?" with "Information..."]

  step %[I click the "Continue" button]
end
