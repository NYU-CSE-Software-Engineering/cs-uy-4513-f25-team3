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

Given(/^I am a signed-in organizer$/) do
  @user ||= User.create!(
    username: 'john_organizer',
    password: 'password',
    password_confirmation: 'password',
    role: 'organizer'
  )

  visit login_path
  fill_in 'Username', with: 'john_organizer' 
  fill_in 'Password', with: 'password'
  click_button 'Login'
end

Given(/^I have created the following itinerary:$/) do |table|
  attrs = table.rows_hash.symbolize_keys
  
  @itinerary = ItineraryGroup.create!(
    title: attrs[:title],
    description: attrs[:description],
    location: attrs[:location],
    start_date: Date.parse(attrs[:start_date]),
    end_date: Date.parse(attrs[:end_date]),
    is_private: attrs[:is_private] == 'Private',
    cost: attrs[:cost].to_f,
    organizer_id: @user.id
  )
end

Given(/^the following itinerary exists:$/) do |table|
  attrs = table.rows_hash.symbolize_keys
  itinerary = ItineraryGroup.new(attrs)

  organizer = User.find_or_create_by!(username: 'izzyadams11') do |user|
    user.password = 'securepass'
    user.password_confirmation = 'securepass'
    user.role = 'organizer'
  end

  itinerary.trip_type = attrs["is_private"]
  itinerary.organizer_id = organizer.id
  itinerary.save!
end

When(/^I try to visit the itinerary settings page for "(.*)"$/) do |title|
  find_itinerary!(title)
  visit edit_itinerary_path(@itinerary)
end

Then(/^I should be redirected to the itinerary page for "(.*)"$/) do |title|
  find_itinerary!(title)
  expect(page).to have_current_path(itinerary_path(@itinerary))
end


Given(/^I am on the itinerary settings page for "(.*)"$/) do |title|
  find_itinerary!(title)
  visit edit_itinerary_path(@itinerary)
end

Then(/^I should be on the itinerary page for "(.*)"$/) do |title|
  if @itinerary
    @itinerary.reload
    expect(page.current_path).to eq(itinerary_path(@itinerary))
  else
    itinerary = ItineraryGroup.find_by!(title: title)
    expect(page.current_path).to eq(itinerary_path(itinerary))
  end
end


Then(/^I should see an editable "(.*)" field prefilled with "(.*)"$/) do |label, value|
  map = {
    'Title' => 'itinerary_group_title',
    'Description' => 'itinerary_group_description',
    'Location' => 'itinerary_group_location',
    'Start Date' => 'itinerary_group_start_date',
    'End Date' => 'itinerary_group_end_date',
    'Trip Cost' => 'itinerary_group_cost'
  }
  
  map_id = map[label] || label
  
  if label == 'Trip Cost'
    actual_value = find_field(map_id).value
    expect(actual_value.to_f).to eq(value.to_f)
  else
    expect(page).to have_field(map_id, with: value)
  end
end

Then(/^I should see an editable "(.*)" selector prefilled with "(.*)"$/) do |label, selected|
  expect(page).to have_select(label, selected: selected)
end


When(/^I fill in "(.*)" with "(.*)"$/) do |label, value|
  map = {
    'Title' => 'itinerary_group_title',
    'Description' => 'itinerary_group_description',
    'Location' => 'itinerary_group_location',
    'Start Date' => 'itinerary_group_start_date',
    'End Date' => 'itinerary_group_end_date',
    'Trip Cost' => 'itinerary_group_cost',
    'Trip Password' => 'itinerary_group_password'
  }
  
  map_id = map[label] || label
  fill_in map_id, with: value
end

When(/^I select "(.*)" from "(.*)"$/) do |option, label|
  select option, from: 'itinerary_group_is_private'
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


Given(/^a user "(.*)" with password "(.*)" and role "(.*)" exists$/) do |username, password, role|
  @other_user = User.create!(
    username: username,
    password: password,
    password_confirmation: password,
    role: role
  )
end

Given(/^"(.*)" is logged in$/) do |username|
  visit login_path
  fill_in 'Username', with: username 
  fill_in 'Password', with: 'password'
  click_button 'Login'
end

Given(/^an itinerary "(.*)" exists organized by another user$/) do |title|
  another_organizer = User.find_or_create_by!(username: 'other_organizer') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.role = 'organizer'
  end

  @itinerary = ItineraryGroup.create!(
    title: title,
    description: 'Exploring NYC',
    location: 'New York',
    start_date: Date.parse('2026-01-01'),
    end_date: Date.parse('2026-01-14'),
    is_private: false,
    cost: 2400,
    organizer_id: another_organizer.id
  )
end