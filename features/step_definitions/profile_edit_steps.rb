def find_user!(user_id)
  @user = User.find_by(user_id: user_id)
end

Given(/^the following Users exist:$/) do |table|
  table.hashes.each do |row|
    User.create!(
      user_id: row['UserID'].to_i,
      first_name: row['FirstName'],
      last_name: row['LastName'],
      username: row['Username'],
      password: row['Password'],
      age: row['Age'].to_i,
      gender: row['Gender']
    )
  end
end

Given(/^I am UserID (\d+)$/) do |user_id|
  find_user!(user_id.to_i)
  @current_user = @user
  @old_password = @user.password
end

When(/^I enter my current password correctly$/) do
  expect(@current_user.password).not_to be_nil
end

When(/^I enter "(.*)" as my new unique username$/) do |new_username|
  @current_user.username = new_username
end

When(/^I enter "(.*)" as my new password$/) do |new_password|
  @current_user.password = new_password
end

When(/^I confirm it by typing "(.*)" again$/) do |confirmation|
  if @current_user.password != confirmation
    raise "Password confirmation does not match"
  end
end

When(/^I update my age to (\d+)$/) do |age|
  @current_user.age = age.to_i
end

When(/^I update my first name to "(.*)"$/) do |first_name|
  @current_user.first_name = first_name
end

When(/^I update my last name to "(.*)"$/) do |last_name|
  @current_user.last_name = last_name
end

When(/^I update my gender to "(.*)"$/) do |gender|
  @current_user.gender = gender
end

When(/^I press "(.*)"$/) do |button|
  @current_user.save
end

Then(/^my username should be updated to "(.*)"$/) do |new_username|
  expect(@current_user.username).to eq(new_username)
end

Then(/^I should be able to log in only with "(.*)"$/) do |new_password|
  expect(@current_user.password).to eq(new_password)
end

Then(/^the old password should no longer work$/) do
  expect(@current_user.password).not_to eq(@old_password)
end

Then(/^my age should be updated to (\d+) on my profile$/) do |age|
  expect(@current_user.age).to eq(age.to_i)
end

Then(/^my full name should be displayed as "(.*)" on my profile$/) do |full_name|
  expect("#{@current_user.first_name} #{@current_user.last_name}").to eq(full_name)
end

Then(/^my gender should be updated to "(.*)"$/) do |gender|
  expect(@current_user.gender).to eq(gender)
end
