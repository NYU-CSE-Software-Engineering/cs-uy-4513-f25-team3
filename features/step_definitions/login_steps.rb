Given('a user exists with username {string} and password {string}') do |username, password|
  @user = User.create!(username: username, password: password, role: "user")
end

Given('I am on the login page') do
  visit login_path
end



Given('an organizer exists with username {string} and password {string}') do |username, password|
  @organizer = User.create!(username: username, password: password, role: "organizer")
end




Then('I should receive an error') do
  expect(page).to have_content("Invalid username and/or password")
end

Then('the login page should refresh to blank') do
  expect(page).to have_field("Username", with: "")
  password_value = find_field("Password").value
  expect(password_value.nil? || password_value == "").to be true
end
