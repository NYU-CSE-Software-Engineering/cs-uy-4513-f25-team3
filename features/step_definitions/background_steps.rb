require 'time'

Given('the following Users exist:') do |table|
  # table.columns: UserID, Username
  table.hashes.each do |row|
    User.find_or_create_by!(id: row['UserID'].to_i) do |u|
      u.username = row['Username']
    end
  end
end

Given('the following ItineraryGroups exist:') do |table|
  # table.columns: ItineraryGroupID, GroupName
  table.hashes.each do |row|
    ItineraryGroup.find_or_create_by!(id: row['ItineraryGroupID'].to_i) do |g|
      g.group_name = row['GroupName']
    end
  end
end

Given('the following Messages exist:') do |table|
  # table.columns: MessageID, UserID, ItineraryGroupID, Text, Time
  table.hashes.each do |row|
    Message.find_or_create_by!(id: row['MessageID'].to_i) do |m|
      m.user_id = row['UserID'].to_i
      m.itinerary_group_id = row['ItineraryGroupID'].to_i
      m.text = row['Text']
      m.time = Time.iso8601(row['Time']) 
    end
  end
end

Given('I am UserID {int}') do |user_id|
  @current_user_id = user_id
end

Given('I am on the group chat for ItineraryGroupID {int}') do |group_id|
  id = group_id.to_i
  visit("/itinerary_groups/#{id}/messages")
end
