require 'time'
require 'date'

Given('the following ItineraryGroups exist:') do |table|
  # table.columns: ItineraryGroupID, Title, StartDate, EndDate
  table.hashes.each do |row|
    ItineraryGroup.find_or_create_by!(id: row['ItineraryGroupID'].to_i) do |g|
      g.title      = row['Title'] || "Group #{row['ItineraryGroupID']}"
      g.start_date = Date.parse(row['StartDate'] || Date.today.to_s)
      g.end_date   = Date.parse(row['EndDate']   || g.start_date.to_s)
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

# Given('I am UserID {int}') do |user_id|
#   @current_user_id = user_id
# end

Given('I am on the group chat for ItineraryGroupID {int}') do |group_id|
  id = group_id.to_i
  user = @current_user || begin
    session_data = page.get_rack_session
    User.find_by(id: session_data[:user_id])
  end

  if user
    ItineraryAttendee.find_or_create_by!(
      itinerary_group_id: id,
      user_id: user.id
    )
  end

  visit("/itineraries/#{id}/messages")
end
