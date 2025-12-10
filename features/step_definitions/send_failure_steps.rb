When(/^I attempt to send "([^"]*)" to ItineraryGroupID (\d+) and the request fails$/) do |text, group_id|
  page.set_rack_session(simulate_message_failure: true)
  visit("/itineraries/#{group_id}/messages")
  chat_input!.set(text)
  send_button_click!
end

Then(/^no new Message exists with \(UserID: (\d+), ItineraryGroupID: (\d+), Text: "([^"]+)"\)$/) do |user_id, group_id, text|
  expect(
    Message.exists?(user_id: user_id.to_i, itinerary_group_id: group_id.to_i, text: text)
  ).to be(false)
end

Then('an error is shown for the failed send') do
  expect(
    page.has_text?('Unable to send')
  ).to be(true), 'Expected a visible send error'
end
