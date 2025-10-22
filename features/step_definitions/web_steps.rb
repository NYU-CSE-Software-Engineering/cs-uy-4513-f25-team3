Given(/I am on the (.*) page/) do |page_name|
    visit path_to(page_name)
end

When(/^I click "(.*)"$/) do |link_text|
  click_link_or_button(link_text)
end

Then(/^I should see (a message|an error) "(.*)"$/) do |type, text|
  expect(page).to have_content(text)
end
