require 'spec_helper'

describe Event do

  subject(:event) { Event.new("Eurucamp", Date.parse("2012-10-10"), Date.parse("2012-12-12")) }

  describe "#new" do
    its(:name) { should == "Eurucamp" }
    its(:start_time) { should == Date.parse("2012-10-10") }
    its(:end_time) { should == Date.parse("2012-12-12") }
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
    let(:event) { Event.new }
    subject { event.activities }

    before do
      event.all_activities_fetcher = ->{ activities }
    end

    it { should == activities }
  end

end