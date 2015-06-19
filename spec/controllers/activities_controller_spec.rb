require 'rails_helper'

RSpec.describe ActivitiesController do
  let(:current_user) { mock_model(User) }

  let(:activity) { stub_model(Activity, creator: current_user) }
  let(:activity_id) { "1" }
  let(:invalid_activity) { double(:invalid_activity, errors: {name: "no way!"}) }
  let(:current_event) { double(:current_event) }

  before do
    allow(controller).to receive(:current_event).and_return(current_event)
  end

  describe "#index" do
    subject { get :index }

    let(:current_user)  { nil }
    let(:activities)    { [ activity ] }
    let(:counters)      { double(:counters) }

    before do
      expect(current_event).to receive(:search_activities).with(current_user, nil, nil).and_return(activities)
      expect(current_event).to receive(:counters).with(current_user).and_return(counters)
    end

    it { is_expected.to be_success }
  end

  describe "#show" do
    subject { get :show, id: activity_id }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
    end

    context "activity doesn't exist" do
      let(:activity) { nil }

      it { is_expected.to have_http_status(404) }
    end

    context "activity exists" do
      before do
        expect(activity).to receive(:decorate).and_return(activity)
      end

      it { is_expected.to be_success }
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
        expect(current_event).to receive(:new_activity).with(current_user, attributes.with_indifferent_access).and_return(activity)
        expect(activity).to receive(:save).and_return(true)
        expect(activity).to receive(:decorate).and_return(activity)
      end

      it { is_expected.to have_http_status(201) }
    end

    context "invalid parameters" do
      let(:activity) { invalid_activity }
      let(:params) { {activity: {x: 10}} }

      before do
        expect(current_event).to receive(:new_activity).with(current_user, {}).and_return(activity)
        expect(activity).to receive(:save).and_return(false)
      end

      it { is_expected.to have_http_status(400) }
    end
  end

  describe "#update" do
    subject { put :update, params }
    let(:params) { {id: activity_id, activity: attributes} }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
      expect(activity).to receive(:decorate).and_return(activity)
      should_authorize(:update, activity)
    end

    context "valid parameters" do
      let(:attributes) { {location: "Location", name: "Name", start_time: 1.day.ago.to_s, end_time: 2.days.ago.to_s} }

      before do
        expect(activity).to receive(:update_attributes).with(attributes.with_indifferent_access).and_return(true)
      end

      it { is_expected.to have_http_status(200) }
    end

    context "invalid parameters" do
      let(:attributes) { {location: ""} }
      let(:activity) { invalid_activity }

      before do
        expect(activity).to receive(:update_attributes).with(attributes.with_indifferent_access).and_return(false)
      end

      it { is_expected.to have_http_status(400) }
    end
  end

  describe "#destroy" do
    subject { delete :destroy, {id: activity_id} }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
      expect(activity).to receive(:decorate).and_return(activity)
      should_authorize(:destroy, activity)
      expect(activity).to receive(:destroy).and_return(true)
    end

    it { is_expected.to have_http_status(204) }
  end

end
