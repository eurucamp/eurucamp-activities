require 'spec_helper'

describe ParticipationsController do
  let(:current_user) { mock_model(User) }
  let(:activity_id) { "1" }
  let(:activity) { double(:activity) }
  let(:participation) { double(:participation) }
  let(:invalid_participation) { double(:participation, errors: {activity_id: "nahhhhh"}) }
  let(:current_event) { double(:current_event) }

  before do
    activity.stub(:reload).and_return(activity)
    controller.stub(:current_event).and_return(current_event)
  end

  describe "#create" do
    context "with :js format" do
      subject { post :create, {activity_id: activity_id, format: :js} }

      before do
        sign_in(current_user)

        current_event.should_receive(:activity).with(activity_id).and_return(activity)
        activity.should_receive(:decorate).and_return(activity)
        activity.should_receive(:new_participation).with(current_user).and_return(participation)
      end

      context "valid parameters" do

        before do
          participation.should_receive(:save).and_return(true)
        end

        it { should render_template(:create) }
      end

      context "user is already a participant" do
        let(:participation) { invalid_participation }

        before do
          participation.should_receive(:save).and_return(false)
        end

        # TODO: moar specs needed
        it { should render_template(:create) }
      end
    end
  end

  describe "#destroy" do
    context "with :js format" do
      subject { delete :destroy, {activity_id: activity_id, format: :js} }

      before do
        sign_in(current_user)

        current_event.should_receive(:activity).with(activity_id).and_return(activity)
        activity.should_receive(:decorate).and_return(activity)

        activity.should_receive(:participation).with(current_user).and_return(participation)
        should_authorize(:destroy, participation)

        participation.should_receive(:destroy).and_return(true)
      end

      # TODO: moar specs needed
      it { should render_template(:destroy) }
    end
  end

end