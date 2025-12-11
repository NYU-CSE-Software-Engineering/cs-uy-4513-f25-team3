def find_itinerary_group!(title)
  @itinerary_group = ItineraryGroup.find_by!(title: title)
end

Given(/^the following users exist:$/) do |table|
  table.hashes.each do |row|
    User.create!(
      first_name: row['first_name'],
      last_name: row['last_name'],
      username: row['username'],
      password: row['password'],
      password_confirmation: row['password'],
      role: row['role']
    )
  end
end

Given(/^I am logged in as "(.*)" with password "(.*)"$/) do |username, password|
  @current_user = User.find_by!(username: username)
  visit login_path
  fill_in 'Username', with: username
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given(/^the following itinerary group exists:$/) do |table|
  attrs = table.rows_hash
  organizer = User.find_by!(username: attrs['organizer'])
  
  start_date = attrs['start_date'] || Date.today
  end_date = attrs['end_date'] || Date.today + 7.days
  
  @itinerary_group = ItineraryGroup.create!(
    title: attrs['title'],
    description: attrs['description'],
    organizer_id: organizer.id,
    start_date: start_date,
    end_date: end_date,
    is_private: attrs['is_private'] == 'true',
    password: attrs['password']
  )
  
  ItineraryAttendee.find_or_create_by!(
    user_id: organizer.id,
    itinerary_group_id: @itinerary_group.id
  )
end

Given(/^I have created an itinerary group titled "(.*)"$/) do |title|
  @itinerary_group = ItineraryGroup.create!(
    title: title,
    organizer_id: @current_user.id,
    start_date: Date.today,
    end_date: Date.today + 7.days,
    is_private: false
  )
  
  ItineraryAttendee.find_or_create_by!(
    user_id: @current_user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

Given(/^I am a member of the group "(.*)"$/) do |title|
  find_itinerary_group!(title)
  ItineraryAttendee.find_or_create_by!(
    user_id: @current_user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

Given(/^"(.*)" is a member of the group "(.*)"$/) do |username, title|
  user = User.find_by!(username: username)
  find_itinerary_group!(title)
  ItineraryAttendee.find_or_create_by!(
    user_id: user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

When(/^"(.*)" joins the group "(.*)"$/) do |username, title|
  user = User.find_by!(username: username)
  find_itinerary_group!(title)
  ItineraryAttendee.find_or_create_by!(
    user_id: user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

When(/^"(.*)" leaves the group "(.*)"$/) do |username, title|
  user = User.find_by!(username: username)
  find_itinerary_group!(title)
  attendee = ItineraryAttendee.find_by!(
    user_id: user.id,
    itinerary_group_id: @itinerary_group.id
  )
  attendee.destroy
end

When(/^I visit the itinerary page for "(.*)"$/) do |title|
  find_itinerary_group!(title)
  visit itinerary_path(@itinerary_group)
end

When(/^I attempt to visit the itinerary page for "(.*)"$/) do |title|
  begin
    find_itinerary_group!(title)
    visit itinerary_path(@itinerary_group)
  rescue ActiveRecord::RecordNotFound
    visit itineraries_path
  end
end

Given(/^I am logged out$/) do
  page.set_rack_session(user_id: nil)
end

Then(/^I should be redirected to the login page$/) do
  expect(current_path).to eq(login_path)
end

Then(/^I should see an error message$/) do
  expect(page.text).to match(/error|denied|access|not found|doesn't exist/i)
end