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
  visit login_path
  fill_in 'Username', with: username
  fill_in 'Password', with: password
  click_button 'Login'
  @current_user = User.find_by!(username: username)
end

Given(/^the following itinerary group exists:$/) do |table|
  attrs = table.rows_hash
  organizer = User.find_by!(username: attrs['organizer'])
  
  group_attrs = {
    title: attrs['title'],
    description: attrs['description'],
    organizer_id: organizer.id,
    is_private: attrs['is_private'] == 'true',
    start_date: attrs['start_date'] || Date.today,
    end_date: attrs['end_date'] || (Date.today + 7.days) 
  }
  
  if attrs['is_private'] == 'true'
    group_attrs[:password] = attrs['password'] || 'DefaultPass123!'
  end
  
  @itinerary_group = ItineraryGroup.create!(group_attrs)
end

Given(/^I have created an itinerary group titled "(.*)"$/) do |title|
  @itinerary_group = ItineraryGroup.create!(
    title: title,
    organizer_id: @current_user.id,
    is_private: false,
    start_date: Date.today,
    end_date: Date.today + 7.days
  )
end

Given(/^I am a member of the group "(.*)"$/) do |title|
  find_itinerary_group!(title)
  # Set @current_user if not already set (for scenarios without login)
  @current_user ||= User.first
  ItineraryAttendee.create!(
    user_id: @current_user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

Given(/^"(.*)" is a member of the group "(.*)"$/) do |username, title|
  user = User.find_by!(username: username)
  find_itinerary_group!(title)
  ItineraryAttendee.create!(
    user_id: user.id,
    itinerary_group_id: @itinerary_group.id
  )
end

When(/^"(.*)" joins the group "(.*)"$/) do |username, title|
  user = User.find_by!(username: username)
  find_itinerary_group!(title)
  ItineraryAttendee.create!(
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
  visit itinerary_group_path(@itinerary_group)
end

When(/^I attempt to visit the itinerary page for "(.*)"$/) do |title|
  begin
    find_itinerary_group!(title)
    visit itinerary_group_path(@itinerary_group)
  rescue ActiveRecord::RecordNotFound
    # Group doesn't exist - visit with fake ID to trigger controller error handling
    visit "/itinerary_groups/999999"
  end
end

# Custom steps unique to this feature
Then(/^I should see either "(.*)" or "(.*)"$/) do |text1, text2|
  expect(page.text).to match(/#{text1}|#{text2}/i)
end

Given(/^I am logged out$/) do
  visit logout_path if defined?(logout_path)
end

Then(/^I should be redirected to the login page$/) do
  expect(current_path).to eq(login_path)
end

Then(/^I should see an error message$/) do
  expect(page.text).to match(/error|denied|access|private|not found|doesn't exist/i)
end