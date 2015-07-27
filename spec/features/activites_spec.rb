require 'rails_helper'

RSpec.describe "Activities", :type => :feature do
  let!(:event) { Event.new }
  let!(:creator) do
    User.create!(
      name: 'Creatoratorius',
      email: 'test@example.com',
      password: 'foobarbaz'
    )
  end
  let!(:participant) do
    User.create!(
      name: 'Participanto',
      email: 'toast@example.com',
      password: 'foobarbaz'
    )
  end
  let!(:anonymous_participant) do
    User.create!(
      name: 'AnonUser',
      email: 'anon@example.com',
      password: 'foobarbaz',
      show_participation: false
    )
  end
  let!(:activity) do
    Activity.create!(
      start_time: Time.zone.local(2015, 7, 30, 10),
      end_time: Time.zone.local(2015, 7, 30, 11),
      name: 'Test Activity',
      location: 'There',
      creator_id: creator.id,
      event: event
    )
  end

  before do
    activity.participants << participant
    activity.participants << anonymous_participant
  end


  context 'viewing an activity' do
    it "view activity" do
      login_as(participant)
      visit "/activities/#{activity.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath('//li[@title="Participanto"]')
      expect(page).not_to have_xpath('//li[@title="AnonUser"]')
      expect(page).to have_xpath('//li[@title="Anonymous"]')
    end
  end
end
