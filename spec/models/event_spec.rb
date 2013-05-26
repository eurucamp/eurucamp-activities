require 'spec_helper'

describe Event do

  subject(:event) { Event.new("Eurucamp") }

  describe "#new" do
    its(:name) { should == "Eurucamp" }
  end

  describe "#new_activity" do
    let(:user) { mock_model(User) }
    let(:new_activity) { OpenStruct.new }
    let(:args) { {} }
    subject { event.new_activity(user, args) }

    before do
      event.activity_source = ->(x){ new_activity }
    end

    its(:event) { should == event }
    it { should == new_activity }
  end

  describe "#activities" do
    let(:activities) { [mock(:activity1), mock(:activity2)] }
    let(:event) { Event.new("Conf", ->{ activities }) }
    subject { event.activities }

    it { should == activities }
  end

end