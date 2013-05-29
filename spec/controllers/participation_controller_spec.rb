require 'spec_helper'

describe ParticipationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:activity) { FactoryGirl.create(:activity) }

  describe "#create" do
    context "format :json" do
      subject { post :create, {activity_id: activity.id, format: :json} }

      before do
        sign_in(user)
      end

      context "valid parameters" do
        its(:status) { should == 201 }
      end

      context "user is already a participant" do
        before do
          Participation.create(participant: user, activity: activity)
        end

        its(:status) { should == 422 }
      end
    end
  end

  describe "#destroy" do
    context "format :json" do
      subject { delete :destroy, {activity_id: activity.id, format: :json} }

      before do
        sign_in(user)
      end

      its(:status) { should == 204 }
    end
  end

end