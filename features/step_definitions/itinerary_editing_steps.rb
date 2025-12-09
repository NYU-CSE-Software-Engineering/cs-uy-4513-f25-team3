def find_itinerary!(title)
  @itinerary = ItineraryGroup.find_by!(title: title)
end

Given(/^I am a signed-in user$/) do
  @user ||= User.create!(
    username: 'john123',
    password: 'password',
    password_confirmation: 'password',
    role: 'user'
  )

  visit login_path
  fill_in 'user_username', with: 'john123'
  fill_in 'user_password', with: 'password'
  click_button 'Login'
end

Given(/^the following itinerary exists:$/) do |table|
  attrs = table.rows_hash.symbolize_keys
  ItineraryGroup.create!(attrs)
end
Given(/^I am on the itinerary settings page for "(.*)"$/) do |title|
  find_itinerary!(title)
  visit edit_itinerary_path(@itinerary)
end

Then(/^I should be on the itinerary page for "(.*)"$/) do |title|
  find_itinerary!(title)
  expect(page).to have_current_path(itinerary_path(@itinerary))
end


Then(/^I should see an editable "(.*)" field prefilled with "(.*)"$/) do |label, value|
  expect(page).to have_field(label, with: value)
end

Then(/^I should see an editable "(.*)" selector prefilled with "(.*)"$/) do |label, selected|
  expect(page).to have_select(label, selected: selected)
end


When(/^I fill in "(.*)" with "(.*)"$/) do |label, value|
  fill_in label, with: value
end

When(/^I select "(.*)" from "(.*)"$/) do |option, label|
  select option, from: label
end

When(/^I press "(.*)"$/) do |button|
  click_button button
end

Then(/^I should see the message "(.*)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should see the error "(.*)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should see "(.*)"$/) do |text|
  expect(page).to have_content(text)
end
