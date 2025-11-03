Given('I am on the login page') do
  visit '/login'
end

Given('a user exists with username {string} and password {string}') do |username, password|
  @user = User.create!(username: username, password: password, role: "user")
end

Given('an organizer exists with username {string} and password {string}') do |username, password|
  @organizer = Organizer.create!(username: username, password: password, role: "organizer")
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I click {string}') do |submit|
  click_button submit
end

Then('I should be on my user homepage') do
  expect(current_path).to eq(user_path(@user))
end

Then('I should be on my organizer homepage') do
  expect(current_path).to eq(organizer_path(@organizer))
end

Then('I should receive an error') do
  expect(page).to have_content("Invalid username and/or password")
end

Then('the login page should refresh to blank') do
  expect(find_field('Username').value).to eq("")
  expect(find_field('Password').value).to eq("")
end







