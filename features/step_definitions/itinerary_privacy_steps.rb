Given('I am logged in as organizer {string}') do |username|
  organizer = Organizer.find_or_create_by!(username: username, password: 'securepass')
  page.set_rack_session(organizer_id: organizer.id)
end

Given('I enter {string} as my trip password') do |password|
  fill_in 'Trip Password', with: password
end

Then('users must enter a password to join') do
  itinerary = Itinerary.last
  expect(itinerary.trip_type.downcase).to eq('private')
  expect(itinerary.password).to be_present
end

Given('the itinerary {string} is private with password {string}') do |title, password|
  itinerary = Itinerary.find_or_create_by!(title: title)
  itinerary.update!(trip_type: 'private', password: password)
end

Given('I am logged in as user {string}') do |username|
  user = User.find_or_create_by!(username: username, password: 'password123')
  page.set_rack_session(user_id: user.id)
end

When('I visit the join page for {string}') do |title|
  itinerary = Itinerary.find_by!(title: title)
  visit join_itinerary_path(itinerary)
end

When('I enter {string} as the trip password') do |password|
  fill_in 'Trip Password', with: password
end

Then('I should see {string} in my joined trips list') do |trip_name|
  expect(page).to have_content(trip_name)
end

Then('I should be on the join page for {string}') do |title|
  itinerary = Itinerary.find_by!(title: title)
  expect(page.current_path).to eq(join_itinerary_path(itinerary))
end

Then('I should not see {string} in my joined trips list') do |trip_name|
  expect(page).not_to have_content(trip_name)
end

Then('users no longer need a password to join') do
  itinerary = Itinerary.last
  expect(itinerary.trip_type.downcase).to eq('public')
  expect(itinerary.password).to be_blank
end