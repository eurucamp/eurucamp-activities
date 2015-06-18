require "spec_helper"

describe AuthenticationsController do

  let(:current_user) { mock_model(User) }
  let(:authentications) { double(:authentications) }
  let(:authentication) { double(:authentication) }
  let(:authentication_id) { "1" }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(current_user).to receive(:authentications).and_return(authentications)
  end

  describe '#create' do
    subject { post :create }

    before do
      request.env['omniauth.auth'] = omniauth_data
    end

    context "no authentication" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none', info: { email: 'test@john.com', name: 'test'} } }
      it { is_expected.to redirect_to new_user_registration_url }
    end

    context "no authentication or incorrect details" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none', info: {} } }
      it { is_expected.to redirect_to new_user_registration_url }
    end

    context "user already logged in" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none' } }

      before do
        sign_in(current_user)
        expect(authentications).to receive(:find_or_create_by).with({provider: nil, uid: nil})
        expect(current_user).to receive(:apply_provider_handle).with(omniauth_data)
        expect(current_user).to receive(:save).and_return(true)
      end

      context "when HTTP_REFERER set" do
        before do
          request.env['HTTP_REFERER'] = 'http://backtoreality/'
        end

        it { is_expected.to redirect_to 'http://backtoreality/' }
      end

      context "when HTTP_REFERER not set" do

        it { is_expected.to redirect_to edit_user_registration_path }
      end
    end

  end

  describe "#delete" do
    subject(:logout_action) { delete :destroy, id: authentication_id }

    before do
      sign_in(current_user)
      expect(authentications).to receive(:find).with(authentication_id).and_return(authentication)
      should_authorize(:destroy, authentication)
      expect(authentication).to receive(:destroy).and_return(true)
    end

    it { is_expected.to redirect_to authentications_path }
  end

end
