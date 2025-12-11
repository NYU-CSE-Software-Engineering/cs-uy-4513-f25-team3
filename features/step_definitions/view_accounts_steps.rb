Given('I am logged in as an administrator') do
  admin = create(:user, :admin, password: 'password123')
  visit login_path  
  fill_in 'Username', with: admin.username  
  fill_in 'Password', with: 'password123'
  click_button 'Login'
end

Given('the following accounts exist:') do |table|
  table.hashes.each do |row|
    create(:user, username: row['username'], role: row['role'])
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
  expect(page).to have_content('Access Denied')
  expect(current_path).not_to eq(accounts_path)
end

When('I navigate to the Accounts page') do
  visit accounts_path
end


Then('the account {string} should have role {string}') do |username, expected_role|
  card = find('div.card', text: username)

  within(card) do
    actual_role = find_field('Role').value
    expect(actual_role).to eq(expected_role)
  end
end



When('I click the {string} button for {string}') do |action, username|
  account_card = find('div.card', text: username)
  within(account_card) do
    click_button(action)
  end
end


When('I change the role to {string} for {string}') do |role, username|
  card = find('div.card', text: username)
  within(card) do
    select role, from: 'Role'
    click_button('Update Role')
  end
end

