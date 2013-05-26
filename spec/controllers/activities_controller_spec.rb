require 'spec_helper'

describe ActivitiesController do
  describe "#index" do
    subject { get :index }

    it { should render_template(:index) }
    its(:status){ should == 200 }
  end

  describe "#create" do
    context "format :json" do
      subject { post :create, params.merge({format: :json}) }

      before do
        sign_in(FactoryGirl.create(:user))
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

  describe "#destroy"

  describe "#update"

end