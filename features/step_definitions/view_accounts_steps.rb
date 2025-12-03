Given('I am logged in as an administrator') do
  admin = create(:user, :admin, password: 'password123')
  visit login_path  
  fill_in 'Username', with: admin.username  
  fill_in 'Password', with: 'password123'
  click_button 'Login'
end

Given('the following accounts exist') do |table|
  table.hashes.each do |row|
    create(:user, 
      username: row['Username'], 
      role: row['Role']      
    )
  end
  @test_username = table.hashes.first['Username']
end

Then('the Accounts page should not display {string}') do |username|
  expect(page).not_to have_content(username)
end

Then('the Accounts page should display {string}') do |username|
  expect(page).to have_content(username)
end

Given('no user with username {string} exists') do |username|
  user = User.find_by(username: username)
  user.destroy if user
end


Given('I am logged in as a user') do
  user = create(:user, password: 'password123')
  visit login_path  
  fill_in 'Username', with: user.username  
  fill_in 'Password', with: 'password123'
  click_button 'Login'
end

Then('I should be denied access') do
  expect(page).to have_content('Access denied')
  expect(current_path).not_to eq(accounts_path)
end

When('I navigate to the Accounts page') do
  visit accounts_path
end

Given('I change the role to {string}') do |role|
  select(role, from: 'Role')
end

Then('the account {string} should have role {string}') do |username, expected_role|
  account_div = find(".account[data-username='#{username}']")
  expect(account_div).to have_content(expected_role)
end

When('I click {string} for {string}') do |action, username|
  account_div = find(".account[data-username='#{username}']")
  account_div.click_button(action)
end