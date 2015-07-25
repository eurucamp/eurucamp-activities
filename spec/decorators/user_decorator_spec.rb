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

    context 'when the user does not want to be shown in activities' do
      it 'is "Anonymous"' do
        user.name = 'Blubb'
        user.show_participation = false
        expect(subject.name).to eq('Anonymous')
      end
    end
  end

  describe '#avatar_url' do
    it 'returns the avatar url' do
      user.twitter_handle = 'foobar'
      expect(subject.avatar_url(48)).to match /http.*foobar/
    end

    context 'when the user does not want to be shown in activities' do
      it 'is the default Gravatar image' do
        default = 'http://www.gravatar.com/avatar/00000000000000000000000000000000.png?s=48'
        user.twitter_handle = 'foobar'
        user.show_participation = false
        expect(subject.avatar_url(48)).to eq(default)
      end
    end
  end
end
