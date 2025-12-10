def chat_input!
  find('input[data-testid="chat-input"]')
end

def send_button_click!
  find(%([data-testid="chat-send"])).click
end

When(/^I send "([^"]*)" to ItineraryGroupID (\d+)$/) do |text, group_id|
  chat_input!.set(text)
  send_button_click!
end

Then(/^a Message exists with \(UserID: (\d+), ItineraryGroupID: (\d+), Text: "([^"]+)"\)$/) do |user_id, group_id, text|
  using_wait_time 2 do
    expect(
      Message.exists?(user_id: user_id.to_i, itinerary_group_id: group_id.to_i, text: text)
    ).to be(true), "Expected Message(user_id: #{user_id}, itinerary_group_id: #{group_id}, text: #{text}) to exist"
  end
end

Then('no new Message is created') do
  expect(Message.where(text: '').count).to eq(0)
end
