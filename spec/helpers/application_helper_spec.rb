require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#avatar_url' do
    subject { avatar_url(user, size) }
    let(:size) { 64 }

    context 'with a Twitter account' do
      let(:user) { User.new(twitter_handle: 'eurucamp') }
      it { is_expected.to match %r{//twitter.com/#{user.twitter_handle}/profile_image} }
    end

    context 'without a Twitter account' do
      let(:user) { User.new }
      it { is_expected.to match %r{//gravatar.com/avatar/\w+.png\?s=#{size}} }
    end
  end
end
