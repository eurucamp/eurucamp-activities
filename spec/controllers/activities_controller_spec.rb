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

    its(:status){ should == 200 }
  end

  describe "#create" do
    subject { post :create, params }

    before do
      sign_in(user)
    end

    context "valid parameters" do
      let(:params) { {activity: {name: "Pool party", start_time: 2.days.from_now.to_s, end_time: 2.days.from_now.to_s, place: "Pool" }} }
      its(:status) { should == 201 }
    end

    context "invalid parameters" do
      let(:params) { {activity: {x: 10}} }
      its(:status) { should == 422 }
    end
  end

  describe "#update" do
    subject { put :update, params }
    let!(:activity) { FactoryGirl.create(:activity, creator: user) }

    before do
      sign_in(user)
    end

    context "valid parameters" do
      let(:params) { {id: activity.id, activity: {name: "Pool party", start_time: 2.days.from_now.to_s, end_time: 3.days.from_now.to_s, place: "Pool" }} }
      its(:status) { should == 204 }
    end

    context "invalid parameters" do
      let(:params) { {id: activity.id, activity: {start_time: ""}} }
      its(:status) { should == 422 }
    end
  end

  describe "#destroy" do
    subject { delete :destroy, {id: activity.id} }
    let!(:activity) { FactoryGirl.create(:activity, creator: user) }

    before do
      sign_in(user)
    end

    its(:status) { should == 204 }
  end

end