# Given(/I am on the (.*) page/) do |page_name|
#     visit path_to(page_name)
# end

When(/^I click "(.*)"$/) do |link_text|
  click_link_or_button(link_text)
end


Then(/^I should see (a message|an error) "(.*)"$/) do |type, text|
  expect(page).to have_content(text)
end


When('I click {string}') do |submit|
  click_button submit
end

Then(/^I should see (?:a message|an error) "(.*)"$/) do |type, text|
  expect(page).to have_content(text)
end

Then(/^I should be on the (.*) page$/) do |page_name|
  expect(page).to have_current_path(path_to(page_name))
end

When(/^I try to visit the (.*) page$/) do |page_name|
  visit path_to(page_name)
end

Then('I should not see a {string} button') do |button_text|
  expect(page).not_to have_button(button_text)
  expect(page).not_to have_link(button_text)
end

When('I edit MessageID {int} to {string}') do |id, new_text|
  message = Message.find(id)
  message.update!(content: new_text)
end

When('I press {string} on MessageID {int}') do |button_text, id|
  message = Message.find(id)
  click_button(button_text, match: :first)
end

Given('I am on the {string} page') do |page_name|
  visit path_for(page_name)
end

Given('I am on the itineraries page') do
  visit itineraries_path
end
