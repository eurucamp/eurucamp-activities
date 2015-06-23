require 'rails_helper'

RSpec.describe 'Activities API (read-only, unauthenticated)', type: :request do
  describe 'GET /activities' do
    context 'with no activities' do
      it 'provides a response with no activities' do
        get '/activities', {}, { 'Accept' => 'application/vnd.api+json' }

        expect(response.body).to have_json_type(Array).at_path('data')
        expect(response.body).to have_json_size(0).at_path('data')
      end
    end

    context 'with activities' do
      let!(:activities) {  FactoryGirl.create_list(:activity, 2) }

      it 'provides a response with activities' do
        get '/activities', {}, { 'Accept' => 'application/vnd.api+json' }

        expect(response.body).to have_json_type(Array).at_path('data')
        expect(response.body).to have_json_size(2).at_path('data')
        expect(response.body).to be_json_eql(%{{
          "name": "#{activities.first.name}",
          "description": null,
          "requirements": null,
          "location": "Ballroom",
          "start_time": "2013-12-12T18:00:00Z",
          "end_time": "2013-12-13T03:00:00Z",
          "anytime": false,
          "participations_count": 0,
          "limit_of_participants": 10,
          "image_url": null
        }}).at_path('data/0/attributes')
        expect(response.body).to have_json_size(2).at_path('included')
      end
    end
  end

  describe 'GET /activities/:id' do
    let!(:activity) { FactoryGirl.create(:activity) }

    it 'provides a response with the activity' do
      get "/activities/#{activity.id}", {}, { 'Accept' => 'application/vnd.api+json' }

      expect(response.body).to have_json_type(Object).at_path('data')
      expect(response.body).to be_json_eql(%{{
        "name": "#{activity.name}",
        "description": null,
        "requirements": null,
        "location": "Ballroom",
        "start_time": "2013-12-12T18:00:00Z",
        "end_time": "2013-12-13T03:00:00Z",
        "anytime": false,
        "participations_count": 0,
        "limit_of_participants": 10,
        "image_url": null
      }}).at_path('data/attributes')
    end
  end
end
