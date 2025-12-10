# Given(/I am on the (.*) page/) do |page_name|
#     visit path_to(page_name)
# end

When(/^I click "(.*)"$/) do |link_text|
  click_link_or_button(link_text)
end


Then(/^I should see (a message|an error) "(.*)"$/) do |type, text|
  expect(page).to have_content(text)
end

Then(/^I should see "(.*)"$/) do |text|
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
  ensure_message_details_open!(id)
  selector = %([data-testid="edit-input-#{id}"])
  if page.has_selector?(selector, wait: 0)
    field = find(selector)
    field.set(new_text)
  end
end

When('I press {string} on MessageID {int}') do |button_text, id|
  ensure_message_details_open!(id)
  button = find(%([data-testid="save-#{id}"]))
  button.click
end

Given('I am on the {string} page') do |page_name|
  visit path_to(page_name)
end

Given('I am on the itineraries page') do
  visit itineraries_path
end


