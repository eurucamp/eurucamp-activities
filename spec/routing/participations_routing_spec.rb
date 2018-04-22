require 'rails_helper'

RSpec.describe ParticipationsController, type: :routing do
  describe 'routing' do
    it 'does not route to #new' do
      expect(get: '/activities/9/participation/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(get: '/activities/9/participation').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(get: '/activities/9/participation/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/activities/9/participation')
        .to route_to('participations#create', activity_id: '9')
    end

    it 'does not route to #update via PUT' do
      expect(put: '/activities/9/participation').not_to be_routable
    end

    it 'does not route to #update via PATCH' do
      expect(patch: '/activities/9/participation').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/activities/9/participation')
        .to route_to('participations#destroy', activity_id: '9')
    end
  end
end
