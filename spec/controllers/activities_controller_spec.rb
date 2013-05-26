require 'spec_helper'

describe ActivitiesController do
  describe "#index" do
    subject { get :index }

    it { should render_template(:index) }
    its(:status){ should == 200 }
  end

  describe "#create"

  describe "#destroy"

  describe "#update"

end