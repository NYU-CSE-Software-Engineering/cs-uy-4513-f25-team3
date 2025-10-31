Given(/I am on the (.*) page/) do |page_name|
    visit path_to(page_name)
end

When('I press {string}') do |button_text|
  click_button button_text
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
  visit "/#{page_name}"
end
