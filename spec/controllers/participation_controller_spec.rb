require 'rails_helper'

describe ParticipationsController do
  let(:current_user) { mock_model(User) }
  let(:activity_id) { "1" }
  let(:activity) { double(:activity) }
  let(:participation) { double(:participation) }
  let(:invalid_participation) { double(:participation, errors: {activity_id: "nahhhhh"}) }
  let(:current_event) { double(:current_event) }

  before do
    allow(activity).to receive(:reload).and_return(activity)
    allow(controller).to receive(:current_event).and_return(current_event)
  end

  describe "#create" do
    context "with :js format" do
      subject { post :create, {activity_id: activity_id, format: :js} }

      before do
        sign_in(current_user)

        expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
        expect(activity).to receive(:decorate).and_return(activity)
        expect(activity).to receive(:new_participation).with(current_user).and_return(participation)
      end

      context "valid parameters" do

        before do
          expect(participation).to receive(:save).and_return(true)
        end

        it { is_expected.to render_template(:create) }
      end

      context "user is already a participant" do
        let(:participation) { invalid_participation }

        before do
          expect(participation).to receive(:save).and_return(false)
        end

        # TODO: moar specs needed
        it { is_expected.to render_template(:create) }
      end
    end
  end

  describe "#destroy" do
    context "with :js format" do
      subject { delete :destroy, {activity_id: activity_id, format: :js} }

      before do
        sign_in(current_user)

        expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
        expect(activity).to receive(:decorate).and_return(activity)

        expect(activity).to receive(:participation).with(current_user).and_return(participation)
        should_authorize(:destroy, participation)

        expect(participation).to receive(:destroy).and_return(true)
      end

      # TODO: moar specs needed
      it { is_expected.to render_template(:destroy) }
    end
  end

end
