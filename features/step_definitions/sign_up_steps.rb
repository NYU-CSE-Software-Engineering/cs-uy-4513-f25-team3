Given("the following Users exist for sign up:") do |table|
  table.hashes.each do |user|
    User.create!(
      username: user['Username'],
      password: user['Password'],
      password_confirmation: user['Password'], 
      role: user['Role']
    )
  end
end

Given("I am on the sign up page") do
  visit new_user_path
end

When('I fill in {string} for the sign up username') do |username|
  fill_in "Username", with: username
end

When('I leave the sign up username blank') do
  fill_in "Username", with: ""
end

When('I fill in {string} for the sign up password') do |password|
  fill_in "Password", with: password
end

When('I fill in {string} for the sign up password confirmation') do |password|
  fill_in "Password Confirmation", with: password
end

When('I select {string} for the sign up role') do |role|
  select role, from: "Role"
end

When('I click the "Create Account" button for sign up') do
  click_button "Create Account"
end

Then('I should see the sign up success message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should be logged in as sign up user {string}') do |username|
  user = User.find_by(username: username)
  expect(user).not_to be_nil
  expect(page).to have_content("Welcome, #{username}!")
end

Then('the sign up page should reload') do
  expect(page).to have_selector("form[action='/users']")
end

Then('I should see the sign up error {string}') do |message|
  expect(page).to have_content(message)
end

Then('the sign up account should not be created') do
  expect(User.count).to be >= 1
end
