# HELPER
def submit_search_form
  click_button "Search"
end

# GIVEN
Given('the following itineraries exist:') do |table|
  table.hashes.each do |itinerary|
    ItineraryGroup.create!(itinerary)
  end
end

# WHEN
When(/^I filter by dates between "([^"]*)" and "([^"]*)"$/) do |start_date, end_date|
  fill_in 'start_date', with: start_date
  fill_in 'end_date', with: end_date
  submit_search_form
end

When(/^I filter by location "(.*)"$/) do |location|
  fill_in "location", with: location
  submit_search_form
end

When(/^I filter by trip type "(.*)"$/) do |trip_type|
  fill_in "trip_type", with: trip_type
  submit_search_form
end

When(/^I filter itineraries with cost between (\d+) and (\d+)$/) do |min, max|
  fill_in 'min_cost', with: min
  fill_in 'max_cost', with: max
  submit_search_form
end

When('I clear all filters') do
  click_button 'Clear filters'
end

When('I filter itineraries with an invalid cost range') do
  fill_in 'min_cost', with: 'abc'
  submit_search_form
end

When(/^I search for itineraries containing "(.*)"$/) do |keyword|
  fill_in 'search', with: keyword
  submit_search_form
end

Then(/^I should see the following itineraries: (.*)$/) do |itineraries|
  itineraries.split(',').map(&:strip).each do |title|
    expect(page).to have_content(title)
  end
end

Then(/^I should not see the following itineraries: (.*)$/) do |itineraries|
  itineraries.split(',').map(&:strip).each do |title|
    expect(page).not_to have_content(title)
  end
end

Then(/^I should see all itineraries$/) do
  expected_titles = Itinerary.all.map(&:title)
  visible_titles = page.all('.itinerary-title').map(&:text)
  expect(visible_titles).to match_array(expected_titles)
end

Given('I have applied filters') do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I enter "(.*)" in the search box$/) do |keyword|
  fill_in 'keyword', with: keyword
end

When(/^I view the itinerary "(.*)"$/) do |title|
  click_link_or_button(title) # uses generic click step
end

Then(/^I can return to the itineraries page$/) do
  click_link_or_button("Back to results")
  expect(page).to have_current_path(itineraries_path)
end

Then('I should see the following details for {string}') do |title|
  itinerary = Itinerary.find_by(title: title)

  # Check each attribute, show "Not available" if missing
  expect(page).to have_content(itinerary.title || 'Not available')
  expect(page).to have_content(itinerary.description.presence || 'Not available')
  expect(page).to have_content(itinerary.location.presence || 'Not available')
  expect(page).to have_content(itinerary.start_date || 'Not available')
  expect(page).to have_content(itinerary.end_date || 'Not available')
  expect(page).to have_content(itinerary.trip_type.presence || 'Not available')
  expect(page).to have_content(itinerary.cost || 'Not available')
end