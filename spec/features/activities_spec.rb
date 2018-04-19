require 'rails_helper'

RSpec.describe 'Activities', type: :feature do
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
      start_time: Time.zone.local(2018, 4, 15, 10),
      end_time: Time.zone.local(2018, 4, 15, 11),
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
    context 'with JavaScript disabled' do
      it 'view activity' do
        login_as(participant)
        visit "/activities/#{activity.id}"

        expect(page.status_code).to eq(200)
        expect(page).to have_xpath('//li[@title="Participanto"]')
        expect(page).not_to have_xpath('//li[@title="AnonUser"]')
        expect(page).to have_xpath('//li[@title="Anonymous"]')
      end
    end

    context 'with JavaScript enabled', :js do
      it 'view activity' do
        login_as(participant)
        visit "/activities/#{activity.id}"

        expect(page).to have_xpath('//li[@title="Participanto"]')
        expect(page).not_to have_xpath('//li[@title="AnonUser"]')
        expect(page).to have_xpath('//li[@title="Anonymous"]')
      end
    end
  end

  context 'deleting an activity' do
    context 'with JavaScript disabled' do
      it 'deletes activity when checkbox is checked' do
        login_as(creator)
        visit "/activities/#{activity.id}"
        click_link 'Edit'
        check 'Really delete this activity (with currently 2 participants)'
        click_button 'Delete activity'

        get_redirected_to_homepage
        activity_is_deleted
      end

      it 'does not delete activity when checkbox is not checked' do
        login_as(creator)
        visit "/activities/#{activity.id}"
        click_link 'Edit'

        click_button 'Delete activity'

        activity_is_not_deleted
      end
    end

    context 'with JavaScript enabled', :js do
      it 'deletes activity when checkbox is checked' do
        login_as(creator)
        visit "/activities/#{activity.id}"
        click_link 'Edit'
        check 'Really delete this activity (with currently 2 participants)'
        click_button 'Delete activity'

        get_redirected_to_homepage
        activity_is_deleted
      end

      it 'does not delete activity when checkbox is not checked' do
        login_as(creator)
        visit "/activities/#{activity.id}"
        click_link 'Edit'

        click_button 'Delete activity'

        activity_is_not_deleted
      end
    end
  end

  def activity_is_not_deleted
    expect(page).to have_content('Your activity could not be deleted.')
    expect(Activity.exists?(activity.id)).to be_truthy
  end

  def get_redirected_to_homepage
    expect(current_path).to eq(root_path)
  end

  def activity_is_deleted
    expect(page).to have_content('Your activity has been deleted!')
    expect(Activity.exists?(activity.id)).to be_falsy
  end
end
