# GIVEN
Given('the following itineraries exist:') do |table|
  # Log in a test user so require_login passes
  user = User.create!(
    username: "search_user",
    password: "password",
    password_confirmation: "password",
    role: "user"
  )
  page.set_rack_session(user_id: user.id)

  table.hashes.each do |row|
    attrs = row.dup
    if attrs.key?("is_private")
      attrs["trip_type"] = attrs.delete("is_private")
    end

    ItineraryGroup.create!(attrs)
  end
end

# WHEN
When(/^I filter by location "(.*)"$/) do |location|
  fill_in "location", with: location
  submit_search_form
end

When(/^I filter by trip type "(.*)"$/) do |trip_type|
  select trip_type, from: "Trip type"
  submit_search_form
end

When(/^I search for itineraries containing "(.*)"$/) do |keyword|
  fill_in 'search', with: keyword
  submit_search_form
end

Then(/^I should see the following itineraries: (.*)$/) do |itineraries|
  titles = itineraries.split(',').map { |t| t.strip.delete('"') }
  titles.each do |title|
    expect(page).to have_content(title)
  end
end

Then(/^I should not see the following itineraries: (.*)$/) do |itineraries|
  titles = itineraries.split(',').map { |t| t.strip.delete('"') }
  titles.each do |title|
    expect(page).not_to have_content(title)
  end
end

Then(/^I should see all itineraries$/) do
  expected_titles = ItineraryGroup.all.map(&:title)
  visible_titles = page.all('.itinerary-title a:first-child').map(&:text)
  expect(visible_titles).to match_array(expected_titles)
end

When(/^I enter "(.*)" in the search box$/) do |keyword|
  fill_in 'search', with: keyword
end

When(/^I view the itinerary "(.*)"$/) do |title|
  click_link_or_button(title) # uses generic click step
end

Then(/^I can return to the itineraries page$/) do
  if page.has_link?("Back to results")
    click_link_or_button("Back to results")
  end
  expect(page).to have_current_path(itineraries_path)
end


Then('I should see the following details for {string}') do |title|
  itinerary = ItineraryGroup.find_by(title: title)

  if itinerary.is_private
    expect(page).to have_content("This itinerary is private and cannot be viewed.")
  else
    # Check each attribute, show "Not available" if missing
    expect(page).to have_content(itinerary.title || 'Not available')
    expect(page).to have_content(itinerary.description.presence || 'Not available')
    expect(page).to have_content(itinerary.location.presence || 'Not available')
    expect(page).to have_content(itinerary.start_date || 'Not available')
    expect(page).to have_content(itinerary.end_date || 'Not available')
    expect(page).to have_content(itinerary.is_private.presence || 'Not available')
    expect(page).to have_content(itinerary.cost || 'Not available')
  end
end
