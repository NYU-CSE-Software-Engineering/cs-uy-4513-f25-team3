Given ('I am on the hotels page') do
    visit hotels_path
end

When(/^I filter hotels with a minimum rating of "(.*)"$/) do |min_rating|
    fill_in 'min_rating', with: min_rating
    submit_search_form
end

When('I search for hotels in {string}') do |location|
  fill_in 'search_location', with: location
  submit_search_form
end

Given('the following hotels exist:') do |table|
  table.hashes.each do |row|
    Hotel.create!(
      name:           row['name'],
      location:       row['location'],
      rating:         row['rating'],
      arrival_time:   row['arrival_time'],
      departure_time: row['departure_time'],
      cost:           row['cost']
    )
  end
end
