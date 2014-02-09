require 'spec_helper'

describe ActivitiesController do
  let(:current_user) { mock_model(User) }

  let(:activity) { double(:activity) }
  let(:activity_id) { "1" }
  let(:invalid_activity) { double(:invalid_activity, errors: {name: "no way!"}) }
  let(:current_event) { double(:current_event) }

  before do
    controller.stub(:current_event).and_return(current_event)
  end

  describe "#index" do
    subject { get :index }

    let(:current_user)  { nil }
    let(:activities)    { double(:activities) }
    let(:counters)      { double(:counters) }

    before do
      current_event.should_receive(:search_activities).with(current_user, nil, nil).and_return(activities)
      current_event.should_receive(:counters).with(current_user).and_return(counters)
    end

    it { should render_template(:index) }
  end

  describe "#new" do
    subject { get :new }

    before do
      sign_in(current_user)
      current_event.should_receive(:new_activity).with(current_user, {}).and_return(activity)
    end

    it { should render_template(:new) }
  end

  describe "#edit" do
    subject { get :edit, id: activity_id }

    before do
      sign_in(current_user)
      current_event.should_receive(:activity).with(activity_id).and_return(activity)
    end

    context "activity doesn't exist" do
      let(:activity) { nil }

      specify { expect { subject }.to raise_error(ActionController::RoutingError) }
    end

    context "activity exists" do

      before do
        activity.should_receive(:decorate).and_return(activity)
        should_authorize(:edit, activity)
      end

      it { should render_template(:edit) }
    end

  end

  describe "#show" do
    subject { get :show, id: activity_id }

    before do
      sign_in(current_user)
      current_event.should_receive(:activity).with(activity_id).and_return(activity)
    end

    context "activity doesn't exist" do
      let(:activity) { nil }

      specify { expect { subject }.to raise_error(ActionController::RoutingError) }
    end

    context "activity exists" do

      before do
        activity.should_receive(:decorate).and_return(activity)
      end

      it { should render_template(:show) }
    end
  end

  describe "#create" do
    subject { post :create, params }

    before do
      sign_in(current_user)
    end

    context "valid parameters" do
      let(:attributes) { {location: "Location", name: "Name", start_time: 1.day.ago.to_s, end_time: 2.days.ago.to_s} }
      let(:params) { {activity: attributes} }

      before do
        current_event.should_receive(:new_activity).with(current_user, attributes.with_indifferent_access).and_return(activity)
        activity.should_receive(:save).and_return(true)
      end

      it { should redirect_to activities_path }
    end

    context "invalid parameters" do
      let(:activity) { invalid_activity }
      let(:params) { {activity: {x: 10}} }

      before do
        current_event.should_receive(:new_activity).with(current_user, {}).and_return(activity)
        activity.should_receive(:save).and_return(false)
      end

      it { should render_template(:new) }
    end
  end

  describe "#update" do
    subject { put :update, params }
    let(:params) { {id: activity_id, activity: attributes} }

    before do
      sign_in(current_user)
      current_event.should_receive(:activity).with(activity_id).and_return(activity)
      activity.should_receive(:decorate).and_return(activity)
      should_authorize(:update, activity)
    end

    context "valid parameters" do
      let(:attributes) { {location: "Location", name: "Name", start_time: 1.day.ago.to_s, end_time: 2.days.ago.to_s} }

      before do
        activity.should_receive(:update_attributes).with(attributes.with_indifferent_access).and_return(true)
      end

      it { should redirect_to edit_activity_path(activity) }
    end

    context "invalid parameters" do
      let(:attributes) { {location: ""} }
      let(:activity) { invalid_activity }

      before do
        activity.should_receive(:update_attributes).with(attributes.with_indifferent_access).and_return(false)
      end

      it { should render_template(:edit) }
    end
  end

  describe "#destroy" do
    subject { delete :destroy, {id: activity_id} }

    before do
      sign_in(current_user)
      current_event.should_receive(:activity).with(activity_id).and_return(activity)
      activity.should_receive(:decorate).and_return(activity)
      should_authorize(:destroy, activity)
      activity.should_receive(:destroy).and_return(true)
    end

    it { should redirect_to activities_path }

  end

end
