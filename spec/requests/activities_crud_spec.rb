require 'rails_helper'

RSpec.describe 'Activities API (authenticated)', type: :request do
  let(:user)        { FactoryGirl.create(:user) }
  let(:other_user)  { FactoryGirl.create(:user) }
  let(:headers) {
    {
      'Accept'        => 'application/vnd.api+json',
      'Authorization' => %{Token token="#{user.authentication_token}", email="#{user.email}"}
    }
  }

  describe 'POST /activities' do
    it 'creates a new activity' do
      post "/activities", {
        activity: {
          name:         'Free Concert',
          description:  'Great music',
          location:     'Stadium',
          requirements: 'Not a mosh pit'
        }
      }, headers

      expect(response.status).to be 201
      expect(response.body).to have_json_type(Object).at_path('data')
      expect(response.body).to be_json_eql(%{{
        "name": "Free Concert",
        "description": "Great music",
        "requirements": "Not a mosh pit",
        "location": "Stadium",
        "start_time": null,
        "end_time": null,
        "anytime": true,
        "participations_count": 0,
        "limit_of_participants": 10,
        "image_url": null
      }}).at_path('data/attributes')
    end
  end

  describe 'PATCH /activities/:id' do
    context 'when the current user is the creator' do
      let!(:activity) { FactoryGirl.create(:activity, creator: user, anytime: true) }

      it 'updates the activity' do
        patch "/activities/#{activity.id}", {
          activity: {
            name:         'VIP Event',
            description:  'Top secret',
            location:     'Outside',
            requirements: '15 years of RoR knowledge'
          }
        }, headers

        expect(response.status).to be 200
        expect(response.body).to have_json_type(Object).at_path('data')
        expect(response.body).to be_json_eql(%{{
          "name": "VIP Event",
          "description": "Top secret",
          "requirements": "15 years of RoR knowledge",
          "location": "Outside",
          "start_time": null,
          "end_time": null,
          "anytime": true,
          "participations_count": 0,
          "limit_of_participants": 10,
          "image_url": null
        }}).at_path('data/attributes')
      end
    end

    context 'when the current user is not the creator' do
      let!(:activity) { FactoryGirl.create(:activity, creator: other_user, anytime: true) }

      it 'does not update the activity' do
        patch "/activities/#{activity.id}", {}, headers

        expect(response.status).to be 401
        expect(activity.reload).not_to be_nil
      end
    end
  end

  describe 'DELETE /activities/:id' do
    context 'when the current user is the creator' do
      let!(:activity) { FactoryGirl.create(:activity, creator: user, anytime: true) }

      it 'deletes the activity' do
        delete "/activities/#{activity.id}", {}, headers

        expect(response.status).to be 204
        expect { activity.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the current user is not the creator' do
      let!(:activity) { FactoryGirl.create(:activity, creator: other_user, anytime: true) }

      it 'does not delete the activity' do
        delete "/activities/#{activity.id}", {}, headers

        expect(response.status).to be 401
        expect(activity.reload).not_to be_nil
      end
    end
  end
end
