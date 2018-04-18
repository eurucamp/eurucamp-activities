# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationPolicy do
  let(:authentication)      { FactoryGirl.build(:authentication) }
  let(:authentication_user) { authentication.user }
  let(:other_user)          { FactoryGirl.build(:user) }

  subject { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :index? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, authentication)
    end

    it 'denies all users, including authentication user' do
      expect(subject).not_to permit(authentication_user, authentication)
      expect(subject).not_to permit(other_user, authentication)
    end
  end

  permissions :show? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, authentication)
    end

    it 'allows the authentication user' do
      expect(subject).to permit(authentication_user, authentication)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, authentication)
    end
  end

  permissions :create? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, authentication)
    end

    it 'denies the authentication user' do
      expect(subject).not_to permit(authentication_user, authentication)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, authentication)
    end
  end

  permissions :update? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, authentication)
    end

    it 'denies the authentication user' do
      expect(subject).not_to permit(authentication_user, authentication)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, authentication)
    end
  end

  permissions :destroy? do
    it 'denies unauthenticated access' do
      expect(subject).not_to permit(nil, authentication)
    end

    it 'allows the authentication user' do
      expect(subject).to permit(authentication_user, authentication)
    end

    it 'denies all other users' do
      expect(subject).not_to permit(other_user, authentication)
    end
  end
end
