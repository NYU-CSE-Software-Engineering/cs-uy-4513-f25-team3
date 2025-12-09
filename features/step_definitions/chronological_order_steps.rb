Then('MessageIDs are ordered oldest-to-newest') do
  nodes =
    if page.has_selector?('[data-testid="message-item"]', wait: 2)
      all('[data-testid="message-item"]', visible: :all)
    else
      all('[data-message-id]', visible: :all)
    end

  visible_ids = nodes.map { |n|
    n[:'data-testid']&.match(/message-(\d+)/)&.captures&.first || n[:'data-message-id']
  }.compact.map(&:to_i)

  group_id =
    current_path[%r{/(?:itinerary_groups|itineraries)/(\d+)/messages}, 1]&.to_i
  if group_id
    expected_ids = Message.where(itinerary_group_id: group_id).order(time: :asc).pluck(:id)
    expect(visible_ids).to eq(expected_ids), "Expected UI order #{visible_ids} to match chronological #{expected_ids}"
  else
    expect(visible_ids).not_to be_empty
  end
end
