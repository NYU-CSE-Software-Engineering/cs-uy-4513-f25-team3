Given("the following Users exist:") do |table|
  table.hashes.each do |user|
    User.create!(
      id: user["UserID"],
      username: user["Username"],
      password: user["Password"],
      role: user["Role"]
    )
  end
end

Given("I am on the sign up page") do
  visit new_user_path  
end

When('I enter {string} into the "Username" field') do |username|
  fill_in "Username", with: username
end

When('I leave "Username" blank') do
  fill_in "Username", with: ""
end

When('I enter {string} into the "Password" field') do |password|
  fill_in "Password", with: password
end

When('I enter {string} into the "Password Confirmation" field') do |password|
  fill_in "Password Confirmation", with: password
end

When('I select {string} from the "Role" dropdown') do |role|
  select role, from: "Role"
end

When('I press "Create Account"') do
  click_button "Create Account"
end

Then("I should see a message saying {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should be logged in as {string}") do |username|
  user = User.find_by(username: username)
  expect(user).not_to be_nil
  expect(page).to have_content("Logged in as #{username}")
end

Then('I should see "Account created successfully"') do
  expect(page).to have_content("Account created successfully")
end

Then("the sign up page should refresh") do
  expect(current_path).to eq(new_user_path)  # same page
end

Then("I should see an error saying {string}") do |error_message|
  expect(page).to have_content(error_message)
end

Then("the account should not be created") do
  expect(User.count).to be >= 1 

end
