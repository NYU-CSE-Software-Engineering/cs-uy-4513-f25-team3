module MessageHelpers
  def find_message_container!(message_id)
    find(%([data-testid="message-#{message_id}"]))
  end

  def ensure_message_details_open!(message_id)
    details_selector = %([data-testid="message-details-#{message_id}"])
    return if page.has_selector?(details_selector, visible: :visible)

    button_selector = %([data-testid="details-button-#{message_id}"])
    button = find(button_selector)
    button.click
    expect(
      page.has_selector?(details_selector, visible: :visible)
    ).to be(true), "Expected details for MessageID #{message_id} to be visible"
  end
end

World(MessageHelpers)
