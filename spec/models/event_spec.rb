require 'spec_helper'

describe Event do

  let(:start_time) { Date.parse("2012-10-10") }
  let(:end_time) { Date.parse("2012-12-14") }
  subject(:event) { Event.new("Eurucamp", start_time, end_time) }

  let(:proxy) { double(:proxy) }

  describe "#new" do
    its(:name) { should == "Eurucamp" }
    its(:start_time) { should == start_time }
    its(:end_time) { should == end_time }
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
    its(:start_time) { should == start_time }
    its(:end_time) { should == end_time }
  end

  describe "#activity" do
    let(:activity) { OpenStruct.new  }
    let(:activity_id) { 1 }
    subject { event.activity(activity_id) }

    before do
      event.should_receive(:find_activity).with(activity_id).and_return(activity)
    end

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
    let(:activities) { [double(:activity1), double(:activity2)] }
    let(:event) { Event.new }
    subject { event.activities }

    before do
      event.all_activities_fetcher = ->{ activities }
    end

    it { should == activities }
  end

  describe "#search_activities" do
    let(:activities) { [double(:activity1), double(:activity2)] }

    context "default args" do
      subject { event.search_activities }

      before do
        event.all_activities_fetcher = ->{ activities }
      end

      it { should == activities }
    end

    context "by name" do
      subject { event.search_activities(nil, "yummy", "all") }

      before do
        Activity.should_receive(:with_name_like).with("yummy").and_return(activities)
      end

      it { should == activities }
    end

    context "with filter" do
      let(:user) { mock_model(User) }
      subject { event.search_activities(user, "", filter) }

      context "owner" do
        let(:filter) { "owner" }

        before do
          Activity.should_receive(:all_activities).and_return(proxy)
          proxy.should_receive(:created_by).with(user).and_return(activities)
        end

        it { should == activities }
      end

      context "participant" do
        let(:filter) { "participant" }

        before do
          Activity.should_receive(:all_activities).and_return(proxy)
          proxy.should_receive(:participated_by).with(user).and_return(activities)
        end

        it { should == activities }
      end

      context "today" do
        let(:filter) { "today" }

        before do
          Activity.should_receive(:all_activities).and_return(proxy)
          proxy.should_receive(:today).and_return(activities)
        end

        it { should == activities }
      end

      context "wrong filter" do
        let(:filter) { "ownerx" }

        before do
          Activity.should_receive(:all_activities).and_return(activities)
        end

        it { should == activities }
      end

    end

  end

end
