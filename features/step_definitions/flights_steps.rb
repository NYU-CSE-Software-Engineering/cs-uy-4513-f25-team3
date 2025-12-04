Given ('I am on the flights page') do
    visit '/flights'
end

Given('the following flights exist:') do |table|
  table.hashes.each do |row|
    Flight.create!(
      flight_number:       row["flight_number"],
      departure_location:  row["departure_location"],
      arrival_location:    row["arrival_location"],
      departure_time:      row["departure_time"],
      arrival_time:        row["arrival_time"],
      cost:                row["cost"]
    )
  end
end

When('I search for flights departing from {string}') do |location|
  fill_in 'departure_location', with: location
  submit_search_form
end

When('I search for flights arriving at {string}') do |location|
  fill_in 'arrival_location', with: location
  submit_search_form
end
