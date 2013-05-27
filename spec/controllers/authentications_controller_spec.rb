require "spec_helper"

describe AuthenticationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    subject { post :create }

    before do
      request.env['omniauth.auth'] = omniauth_data
    end

    context "no authentication" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none', info: { email: 'test@john.com', name: 'test'} } }
      it { should redirect_to "/" }
    end

    context "no authentication or incorrect details" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none', info: {} } }
      it { should redirect_to new_user_registration_url }
    end

    context "user already logged in" do
      let(:omniauth_data) { { provider: 'none',  uuid: 'none' } }

      before do
        sign_in FactoryGirl.create(:user)
      end

      context "when HTTP_REFERER set" do
        before do
          request.env['HTTP_REFERER'] = 'http://backtoreality/'
        end

        it { should redirect_to 'http://backtoreality/' }
      end

      context "when HTTP_REFERER not set" do
         it { should redirect_to edit_user_registration_path }
      end
    end

  end

  describe "#delete" do
    subject(:logout_action) { delete :destroy, id: authentication.id }
    let(:authentication) { FactoryGirl.create(:authentication) }

    before do
      sign_in authentication.user
    end

    it { should redirect_to authentications_path }

    specify do
      expect { logout_action }.to change(Authentication.count).by(-1)
    end
  end

end
