require 'rails_helper'

RSpec.describe ActivitiesController do
  let(:current_user) { mock_model(User) }

  let(:activity) { mock_model(Activity) }
  let(:activity_id) { '1' }
  let(:invalid_activity) { mock_model(Activity, errors: { name: 'no way!' }) }
  let(:current_event) { double(:current_event) }

  before do
    allow(controller).to receive(:current_event).and_return(current_event)
  end

  describe '#index' do
    subject { get :index }

    let(:current_user) { nil }
    let(:activities_per_day) { double(:activities_per_day) }
    let(:counters) { double(:counters) }

    before do
      expect(current_event).to receive(:activities_per_day).with(current_user, nil, nil).and_return(activities_per_day)
      expect(current_event).to receive(:counters).with(current_user).and_return(counters)
    end

    it { is_expected.to render_template(:index) }
  end

  describe '#new' do
    subject { get :new }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:new_activity).with(current_user, {}).and_return(activity)
    end

    it { is_expected.to render_template(:new) }
  end

  describe '#edit' do
    subject { get :edit, params: { id: activity_id } }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
    end

    context "activity doesn't exist" do
      let(:activity) { nil }

      specify { expect { subject }.to raise_error(ActionController::RoutingError) }
    end

    context 'activity exists' do
      before do
        expect(activity).to receive(:decorate).and_return(activity)
        should_authorize(:edit, activity)
      end

      it { is_expected.to render_template(:edit) }
    end
  end

  describe '#show' do
    subject { get :show, params: { id: activity_id } }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
    end

    context "activity doesn't exist" do
      let(:activity) { nil }

      specify { expect { subject }.to raise_error(ActionController::RoutingError) }
    end

    context 'activity exists' do
      before do
        expect(activity).to receive(:decorate).and_return(activity)
      end

      it { is_expected.to render_template(:show) }
    end
  end

  describe '#create' do
    subject { post :create, params: params }

    before do
      sign_in(current_user)
    end

    context 'valid parameters' do
      let(:attributes) { { location: 'Location', name: 'Name', start_time: 1.day.ago.to_s, end_time: 2.days.ago.to_s } }
      let(:params) { { activity: attributes } }

      before do
        expect(current_event).to receive(:new_activity).with(current_user, ActionController::Parameters.new(attributes).permit!).and_return(activity)
        expect(activity).to receive(:save).and_return(true)
      end

      it { is_expected.to redirect_to activities_path }
    end

    context 'invalid parameters' do
      let(:activity) { invalid_activity }
      let(:params) { { activity: { x: 10 } } }

      before do
        expect(current_event).to receive(:new_activity).with(current_user, ActionController::Parameters.new({}).permit!).and_return(activity)
        expect(activity).to receive(:save).and_return(false)
      end

      it { is_expected.to render_template(:new) }
    end
  end

  describe '#update' do
    subject { put :update, params: params }
    let(:params) { { id: activity_id, activity: attributes } }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
      expect(activity).to receive(:decorate).and_return(activity)
      should_authorize(:update, activity)
    end

    context 'valid parameters' do
      let(:attributes) { { location: 'Location', name: 'Name', start_time: 1.day.ago.to_s, end_time: 2.days.ago.to_s } }

      before do
        expect(activity).to receive(:update).with(ActionController::Parameters.new(attributes).permit!).and_return(true)
      end

      it { is_expected.to redirect_to edit_activity_path(activity) }
    end

    context 'invalid parameters' do
      let(:attributes) { { location: '' } }
      let(:activity) { invalid_activity }

      before do
        expect(activity).to receive(:update).with(ActionController::Parameters.new(attributes).permit!).and_return(false)
      end

      it { is_expected.to render_template(:edit) }
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: activity_id, confirm_delete: true } }

    before do
      sign_in(current_user)
      expect(current_event).to receive(:activity).with(activity_id).and_return(activity)
      expect(activity).to receive(:decorate).and_return(activity)
      should_authorize(:destroy, activity)
      expect(activity).to receive(:destroy).and_return(true)
    end

    it { is_expected.to redirect_to root_path }
  end
end
