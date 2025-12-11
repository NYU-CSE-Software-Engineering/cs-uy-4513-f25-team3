Given('the following Itinerary Groups exist:') do |table|
    table.hashes.each do |row|

        organizer = nil
        if row['Organizer'].present?
            organizer = User.find_by!(username: row['Organizer'])
        end

        start_date = Date.parse(row['Start Date'])
        end_date   = Date.parse(row['End Date'])

        is_private = ActiveModel::Type::Boolean.new.cast(row['Is Private'])

        ItineraryGroup.create!(
        title:       row['Title'],
        description: row['Description'],
        location:    row['Location'],
        start_date:  start_date,
        end_date:    end_date,
        cost:        row['Cost'],
        is_private:  is_private,
        password:    row['Password'],
        organizer:   organizer
        )
    end
end


Given('I am a signed-in user as {string}') do |username|
    @user = User.find_by!(username: username)

    visit login_path 

    fill_in "Username", with: username
    fill_in "Password", with: "password"  

    click_button "Login"  
end


Given('I am on the itinerary details page for {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    visit itinerary_path(itinerary)
end

Then('I should be listed as an attendee of {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    expect(itinerary.users).to include(@user)
end

Then('I should be on the join itinerary page for {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    expect(page.current_path).to eq(join_itinerary_path(itinerary))
end

Then('I should see the itinerary details for {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    expect(page).to have_content(itinerary.title)
    expect(page).to have_content(itinerary.description)
    expect(page).to have_content(itinerary.location)
end

Then('I should not be listed as an attendee of {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    expect(itinerary.users).not_to include(@user)
end

Then('I should not see the itinerary details for {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)

    expect(page).not_to have_content(itinerary.description)
    expect(page).not_to have_content(itinerary.location)
end

Given('I have already joined the itinerary {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    ItineraryAttendee.create!(
        user: @user,
        itinerary_group: itinerary
    )
end

Then('I should not be added as a duplicate attendee for {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    attendees = ItineraryAttendee.where(
        user: @user,
        itinerary_group: itinerary
    )
    expect(attendees.count).to eq(1)
end

When('I try to join the itinerary {string}') do |title|
    itinerary = ItineraryGroup.find_by!(title: title)
    visit join_itinerary_path(itinerary)
end