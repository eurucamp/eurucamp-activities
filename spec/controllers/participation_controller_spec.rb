require 'spec_helper'

describe ParticipationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:activity) { FactoryGirl.create(:activity) }

  describe "#create" do
    context "with :js format" do
      subject { post :create, {activity_id: activity.id, format: :js} }

      before do
        sign_in(user)
      end

      context "valid parameters" do
        it { should render_template(:create) }
      end

      context "user is already a participant" do
        before do
          Participation.create!(participant: user, activity: activity)
        end

        # TODO: moar specs needed
        it { should render_template(:create) }
      end
    end
  end

  describe "#destroy" do
    context "with :js format" do
      subject { delete :destroy, {activity_id: activity.id, format: :js} }

      before do
        Participation.create!(participant: user, activity: activity)
        sign_in(user)
      end

      # TODO: moar specs needed
      it { should render_template(:destroy) }
    end
  end

end