require 'spec_helper'

describe Event do

  subject(:event) { Event.new("Eurucamp", Date.parse("2012-10-10"), Date.parse("2012-12-14")) }

  describe "#new" do
    its(:name) { should == "Eurucamp" }
    its(:start_time) { should == Date.parse("2012-10-10") }
    its(:end_time) { should == Date.parse("2012-12-14") }
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

  describe "#activity" do
    let(:activity) { FactoryGirl.create(:activity, event: event, start_time: "2012-10-11", end_time: "2012-10-13")  }
    subject { event.activity(activity) }

    it { should == activity }
    its(:event) { should == event }
  end

  describe "#recent_activities" do
    let(:recent_activities) { [mock_model(Activity)] }
    subject { event.recent_activities }

    before do
      event.recent_activities_fetcher = ->{ recent_activities }
    end

    it { should == recent_activities }
  end

  describe "#all_activities" do
    let(:activities) { [mock(:activity1), mock(:activity2)] }
    let(:event) { Event.new }
    subject { event.activities }

    before do
      event.all_activities_fetcher = ->{ activities }
    end

    it { should == activities }
  end

  describe "#search_activities" do
    let(:activities) { [mock(:activity1), mock(:activity2)] }

    context "default args" do
      subject { event.search_activities }

      before do
        event.all_activities_fetcher = ->{ activities }
      end

      it { should == activities }
    end

    context "by name" do
      subject { event.search_activities(nil, "yuppy", "all") }

      before do
        Activity.should_receive(:with_name_like).with("yuppy").and_return(activities)
      end

      it { should == activities }
    end

    context "with filter" do
      let(:user) { mock_model(User) }
      subject { event.search_activities(user, "", filter) }

      context "owner" do
        let(:filter) { "owner" }

        before do
          Activity.stub_chain(:all_activities, :created_by).and_return(activities)
        end

        it { should == activities }
      end

      context "participant" do
        let(:filter) { "participant" }

        before do
          Activity.stub_chain(:all_activities, :participated_by).and_return(activities)
        end

        it { should == activities }
      end

      context "today" do
        let(:filter) { "today" }

        before do
          Activity.stub_chain(:all_activities, :today).and_return(activities)
        end

        it { should == activities }
      end

      context "wrong filter" do
        let(:filter) { "ownerx" }

        before do
          Activity.stub_chain(:all_activities).and_return(activities)
        end

        it { should == activities }
      end

    end

  end

end