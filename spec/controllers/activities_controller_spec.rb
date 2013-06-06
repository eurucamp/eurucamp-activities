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
    subject { get :show, {id: activity.id} }

    it { should render_template(:show) }
    its(:status){ should == 200 }
  end

  describe "#create" do
    subject { post :create, params }

    before do
      sign_in(user)
    end

    context "valid parameters" do
      let(:params) { {activity: {name: "Pool party", start_time: 2.days.from_now.to_s, end_time: 2.days.from_now.to_s, location: "Pool" }} }
      it { should redirect_to activities_path }
    end

    context "invalid parameters" do
      let(:params) { {activity: {x: 10}} }
      it { should render_template(:new) }
    end
  end

  describe "#update" do
    subject { put :update, params }
    let!(:activity) { FactoryGirl.create(:activity, creator: user) }

    before do
      sign_in(user)
    end

    context "valid parameters" do
      let(:params) { {id: activity.id, activity: {name: "Pool party", start_time: 2.days.from_now.to_s, end_time: 3.days.from_now.to_s, location: "Pool" }} }
      it { should redirect_to edit_activity_path(activity) }
    end

    context "invalid parameters" do
      let(:params) { {id: activity.id, activity: {location: ""}} }
      it { should render_template(:edit) }
    end
  end

  describe "#destroy" do
    subject { delete :destroy, {id: activity.id} }
    let!(:activity) { FactoryGirl.create(:activity, creator: user) }

    before do
      sign_in(user)
    end

    it { should redirect_to activities_path }
  end

end