require 'spec_helper'

describe ActivitiesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:activity) { FactoryGirl.create(:activity) }

  describe "#index" do
    subject { get :index }

    it { should render_template(:index) }
    its(:status){ should == 200 }
  end

  describe "#show" do
    subject { get :show, {id: activity.id, format: :json} }

    its(:status){ should == 200 }
  end

  describe "#create" do
    context "format :json" do
      subject { post :create, params.merge({format: :json}) }

      before do
        sign_in(user)
      end

      context "valid parameters" do
        let(:params) { {activity: {name: "Pool party", start_at: 2.days.from_now.to_s, place: "Pool", time_frame: 120 }} }
        its(:status) { should == 201 }
      end

      context "invalid parameters" do
        let(:params) { {activity: {x: 10}} }
        its(:status) { should == 422 }
      end
    end
  end

  describe "#update" do
    context "format :json" do
      subject { put :update, params.merge({format: :json}) }
      let!(:activity) { FactoryGirl.create(:activity, creator: user) }

      before do
        sign_in(user)
      end

      context "valid parameters" do
        let(:params) { {id: activity.id, activity: {name: "Pool party", start_at: 2.days.from_now.to_s, place: "Pool", time_frame: 120 }} }
        its(:status) { should == 204 }
      end

      context "invalid parameters" do
        let(:params) { {id: activity.id, activity: {start_at: ""}} }
        its(:status) { should == 422 }
      end
    end
  end

  describe "#destroy" do
    context "format :json" do
      subject { delete :destroy, {id: activity.id, format: :json} }
      let!(:activity) { FactoryGirl.create(:activity, creator: user) }

      before do
        sign_in(user)
      end

      its(:status) { should == 204 }
    end
  end

end