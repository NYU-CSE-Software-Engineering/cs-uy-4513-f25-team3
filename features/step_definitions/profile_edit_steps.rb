# frozen_string_literal: true

Given(/^the following Users exist:$/) do |table|
  table.hashes.each do |row|
    User.create!(
      first_name: row['FirstName'],
      last_name:  row['LastName'],
      username:   row['Username'],
      password:   row['Password'],
      password_confirmation: row['Password'],
      age:        (row['Age'].to_i if row['Age']),
      gender:     row['Gender'],
      role:       row['Role']
    )
  end
end

Given("I am on the profile edit page") do
  # prefer a user from the session if already set, otherwise create/find one
  @current_user ||= User.last || FactoryBot.create(:user)
  page.set_rack_session(user_id: @current_user.id)
  visit edit_user_path(@current_user)
end

Given(/^I am UserID (\d+)$/) do |user_id|
  user = User.find(user_id.to_i)
  @current_user = user
  page.set_rack_session(user_id: user.id)
  @old_password = @current_user.password
end

When(/^I enter my current password "(.*)" correctly$/) do |current_password|
  # the input id is "current_password" (password_field_tag), label "Current password"
  fill_in "current_password", with: current_password
end

When(/^I enter "(.*)" as my new unique username$/) do |new_username|
  fill_in "Username", with: new_username
end

When(/^I enter "(.*)" as my new password$/) do |new_password|
  # matches label "New password" or id "user_password"
  fill_in "New password", with: new_password rescue fill_in "user_password", with: new_password
end

When(/^I confirm it by typing "(.*)" again$/) do |confirmation|
  fill_in "New password confirmation", with: confirmation rescue fill_in "user_password_confirmation", with: confirmation
end

When(/^I update my age to (\d+)$/) do |age|
  fill_in "Age", with: age
end

When(/^I update my first name to "(.*)"$/) do |first_name|
  fill_in "First name", with: first_name rescue fill_in "user_first_name", with: first_name
end

When(/^I update my last name to "(.*)"$/) do |last_name|
  fill_in "Last name", with: last_name rescue fill_in "user_last_name", with: last_name
end

When(/^I update my gender to "(.*)"$/) do |gender|
  # select uses visible option text
  select gender, from: "Gender" rescue select gender, from: "user_gender"
end

When(/^I press "(.*)" for editing the profile$/) do |button|
  # simulate clicking the submit button (e.g. "Save Changes")
  click_button button
end

Then(/^my password should still be "(.*)"$/) do |original_password|
  @current_user.reload
  expect(@current_user.authenticate(original_password)).to be_truthy
end

Then(/^my username should be updated to "(.*)"$/) do |new_username|
  @current_user.reload
  expect(@current_user.username).to eq(new_username)
end

Then(/^I should be able to log in only with "(.*)"$/) do |new_password|
  @current_user.reload
  expect(@current_user.authenticate(new_password)).to be_truthy
end

Then(/^the old password should no longer work$/) do
  @current_user.reload
  expect(@current_user.authenticate(@old_password)).to be_falsey
end

Then(/^my age should be updated to (\d+) on my profile$/) do |age|
  @current_user.reload
  expect(@current_user.age).to eq(age.to_i)
end

Then(/^my full name should be displayed as "(.*)" on my profile$/) do |full_name|
  @current_user.reload
  expect("#{@current_user.first_name} #{@current_user.last_name}").to eq(full_name)
end

Then(/^my gender should be updated to "(.*)" on my profile$/) do |gender|
  @current_user.reload
  expect(@current_user.gender).to eq(gender)
end

# Then(/^I should see a success confirmation message$/) do
#   expect(page).to have_content("Profile updated successfully")
# end

When(/^I try to visit \/edit\/(\d+)$/) do |requested_id|
  requested_user = User.find_by(id: requested_id.to_i) || FactoryBot.create(:user, id: requested_id.to_i)
  visit edit_user_path(requested_user)
end

Then(/^I should not be able to view the page \/edit\/(\d+)$/) do |blocked_id|
  expect(current_path).not_to eq("/users/#{blocked_id}/edit")
end

Then(/^I should be back on \/edit\/(\d+)$/) do |expected_id|
  expect(current_path).to eq("/users/#{expected_id}/edit")
end




