# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityPolicy do
  let(:activity)          { FactoryGirl.build(:activity) }
  let(:activity_creator)  { activity.creator }
  let(:other_user)        { FactoryGirl.build(:user) }

  subject { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :index?, :show? do
    it 'allows unauthenticated access' do
      expect(subject).to permit(nil, activity)
    end

    it 'allows the activity creator' do
      expect(subject).to permit(activity_creator, activity)
    end

    it 'allows all other users' do
      expect(subject).to permit(other_user, activity)
    end
  end

  permissions :create? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, activity)
    end

    it 'allows all other users' do
      expect(subject).to permit(other_user, activity)
    end
  end

  permissions :update?, :destroy? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, activity)
    end

    it 'allows the activity creator' do
      expect(subject).to permit(activity_creator, activity)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, activity)
    end
  end
end
