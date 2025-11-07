Given('I am a signed-in user') do
    @user = User.create!(email: 'test@example.com', password: 'password')
end

When('I fill in the following:') do |table|
    table.rows_hash.each do |field, value|
    fill_in field, with: value
  end
end

Then('I should see the success message {string}') do |message|
    expect(page).to have_content(message)
end

Then('I should be on the home page') do
    expect(current_path).to eq(root_path)
end

Then('I should see {string}') do |content|
  expect(page).to have_content(content)
end

Then('I should see the error message {string}') do |message|
    expect(page).to have_content(message)
end

Then('I should see the error message cost must be greater or equal to {int}') do |int|
    expect(page).to have_content("cost must be greater or equal to #{int}")
end

Then('I should see the error message cost is not a number') do
    expect(page).to have_content('cost is not a number')
end

Then('I should see the error message cost must be an integer') do
    expect(page).to have_content('cost must be an integer')
end

Given('I am not signed in') do
    visit destroy_user_session_path if page.has_link?('Logout')
end

When('I try to visit the new itinerary page') do
    visit new_itinerary_path
end

Then('I should be on the sign in page') do
    expect(current_path).to eq(new_user_session_path)
end