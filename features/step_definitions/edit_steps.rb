def find_message_container!(message_id)
  find(%([data-testid="message-#{message_id}"]))
end

When('I click on MessageID {int}') do |message_id|
  container = find_message_container!(message_id)
  container.click
end

When('I press "Save" on MeassageID {int}') do |message_id|
  container = find(%([data-testid="save-#{message_id}"]))
  container.click
end

Then("I don't see {string}") do |text|
  expect(page).not_to have_text(text)
end

Then('I see {string}') do |text|
  expect(page).to have_text(text)
end

Given('MessageID {int} was edited') do |message_id|
  msg = Message.find(message_id.to_i)
  msg.edited = true
end


Then(/^MessageID (\d+) has Text "([^"]+)"$/) do |message_id, expected_text|
  msg = Message.find(message_id.to_i)
  expect(msg.text).to eq(expected_text)
end

Then('MessageID {int} shows an edited indicator') do |message_id|
  container = find_message_container!(message_id)
  expect(
    container.has_text?('edited')
  ).to be(true), "Expected message #{message_id} to show an edited indicator"
end


