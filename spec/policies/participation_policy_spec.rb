# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipationPolicy do
  let(:participation) { build(:participation) }
  let(:participant)   { participation.participant }
  let(:other_user)    { build(:user) }

  subject { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :index? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, participation)
    end

    it 'denies all users, including participant' do
      expect(subject).not_to permit(participant, participation)
      expect(subject).not_to permit(other_user, participation)
    end
  end

  permissions :show? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, participation)
    end

    it 'allows the participant' do
      expect(subject).to permit(participant, participation)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, participation)
    end
  end

  permissions :create? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, participation)
    end

    it 'denies the participant' do
      expect(subject).not_to permit(participant, participation)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, participation)
    end
  end

  permissions :update? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, participation)
    end

    it 'denies the participant' do
      expect(subject).not_to permit(participant, participation)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, participation)
    end
  end

  permissions :destroy? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, participation)
    end

    it 'allows the participant' do
      expect(subject).to permit(participant, participation)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, participation)
    end
  end
end
