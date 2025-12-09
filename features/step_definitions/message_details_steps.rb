Then('MessageID {int} shows UserID {int}') do |message_id, user_id|
  container = find_message_container!(message_id)
  expect(container.has_text?(user_id.to_s)).to be(true), "Expected message #{message_id} to show UserID #{user_id}"
end

Then('MessageID {int} shows its send time') do |message_id|
  ensure_message_details_open!(message_id)
  container = find_message_container!(message_id)
  expect(
    container.has_selector?(%([data-testid="message-time"]), visible: :visible)
  ).to be(true), "Expected message #{message_id} to show its time"
end

Given('MessageID {int} has been read only by UserID {int}') do |message_id, reader_id|
  if Object.const_defined?('MessageRead')
    MessageRead.where(message_id: message_id).delete_all
    MessageRead.create!(message_id: message_id, user_id: reader_id, read_at: Time.now)
  else
    raise <<~MSG
      Cannot seed read receipts: expected a MessageRead model (message_id, user_id, read_at).
      Please adjust this step to match your schema (e.g., ReadReceipt, Receipt, or a JSON field).
    MSG
  end
end

Then('I should see UserID {int} as read') do |user_id|
  expect(
    page.has_text?("Read: #{user_id}")
  ).to be(true), "Expected to see UserID #{user_id} in the read list"
end


Then('I should see UserID {int} as unread') do |user_id|
  expect(
    page.has_text?("Unread: #{user_id}")
  ).to be(true), "Expected to see UserID #{user_id} in the unread list"
end
