require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { User.new }

  subject do
    UserDecorator.new(user)
  end

  describe '#name' do
    it 'delegates to the user' do
      user.name = 'Blubb'
      expect(subject.name).to eq(user.name)
    end
  end

  describe '#avatar_url' do
    it 'returns the avatar url' do
      user.twitter_handle = 'foobar'
      expect(subject.avatar_url(48)).to match /http.*foobar/
    end
  end
end
