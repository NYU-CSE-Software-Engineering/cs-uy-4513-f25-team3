Given('I am on the new itinerary page') do
  visit new_itinerary_path
end

When('I fill in the following:') do |table|
    table.rows_hash.each do |field, value|
        case field
        when "is_private"
            select value, from: "itinerary_group_is_private"
        else
            fill_in field, with: value
        end
    end
end

Then('I should see the success message {string}') do |message|
    expect(page).to have_content(message)
end

Then('I should be on the home page') do
    expect(current_path).to eq(root_path)
end

Then('I should see the error message {string}') do |message|
    expect(page).to have_content(message)
end

Then('I should see the error message cost must be greater or equal to {int}') do |int|
    expect(page).to have_content("Cost must be greater or equal to #{int}")
end

Then('I should see the error message cost is not a number') do
    expect(page).to have_content('Cost is not a number')
end

Then('I should see the error message cost must be an integer') do
    expect(page).to have_content('Cost must be an integer')
end

Given('I am not signed in') do
    visit destroy_user_session_path if page.has_link?('Logout')
end

Then('I should be on the itinerary settings page for {string}') do |string|
    find_itinerary!(title)
    visit edit_itinerary_path(@itinerary)
end