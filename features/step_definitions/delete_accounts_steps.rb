Given('I am logged in as an administrator') do
  @admin = FactoryBot.create(:user, username: 'adminTest', password: 'password', role: 'admin')
  
  Capybara.using_session(:user_session) do
    visit login_path
    fill_in 'Email', with: @admin.email   
    fill_in 'Password', with: @admin.password
    click_button 'Login'
  end
end

Given('a user with username {string} and password {string} is logged in') do |username, password|
  @user = User.find_by(username: username) || FactoryBot.create(:user, username: username, password: password, role: 'user')

  Capybara.using_session(:user_session) do
    visit login_path
    fill_in 'Email', with: @user.email   
    fill_in 'Password', with: password
    click_button 'Login'
  end
end

When('I select that user account') do
  check("user_#{@user.id}")
end

When('I choose {string} on the confirmation prompt') do |string|
  expect(page).to have_content("Are you sure?")
  click_button string
end

Then('the system should permanently remove that user account') do
  expect(page).not_to have_content(@user.email) 
  expect(User.exists?(@user.id)).to be false
end

Then('the user should be logged out on their next action') do
  Capybara.using_session(:user_session) do
    visit itineraries_path 

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Login") 
  end
end

Then('the user account should still exist in the system') do
  expect(page).to have_content(@user.email) 
  expect(User.exists?(@user.id)).to be true
end

Then('the user should still be logged in') do
  Capybara.using_session(:user_session) do
    visit itineraries_path

    expect(page).not_to have_current_path(login_path)
    expect(page).to have_content("Logout")  
  end
end

Given('no user with username {string} exists') do |string|
  expect(User.find_by(username: string)).to be_nil
end

Then('this account should not appear on the accounts page') do
  expect(page).to_not have_content(@user.email)
end

Given('I am logged in as a user') do
  step 'a user with username "testUser" and password "password" is logged in'
end

Then('I should not be able to access the accounts page') do
  expect(page).to_not have_content("Accounts")
end

Given('I am on the {string} page') do |string|
  expect(page).to have_current_path("/" + string)
end


