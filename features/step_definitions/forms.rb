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
