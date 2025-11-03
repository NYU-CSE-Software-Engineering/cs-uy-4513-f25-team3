Given("my session has expired") do
  # Force-clear the session to simulate timeout
  page.set_rack_session(user_id: nil)
end

Then("I should not have an active session") do
  session_data = page.get_rack_session
  expect(session_data[:user_id]).to be_nil
end

Given("I am not logged in") do
  page.set_rack_session(user_id: nil)
end