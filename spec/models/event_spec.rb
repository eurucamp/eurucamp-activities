require 'spec_helper'

describe Event do

  let(:start_time) { Date.parse("2012-10-10") }
  let(:end_time) { Date.parse("2012-12-14") }
  subject(:event) { Event.new("eurucamp", start_time, end_time) }

  let(:proxy) { double(:proxy) }

  describe "#new" do
    its(:name) { should == "eurucamp" }
    its(:start_time) { should == start_time }
    its(:end_time) { should == end_time }
  end

  describe "#new_activity" do
    let(:user) { mock_model(User) }
    let(:args) { {} }
    subject { event.new_activity(user, args) }

    before do
      event.activity_source = ->(x){ OpenStruct.new(x) }
    end

    context 'with activity defaults' do
      its(:event) { should == event }
      it { expect(subject).to be_a_kind_of OpenStruct }
      its(:start_time) { should == start_time }
      its(:end_time) { should == end_time }
    end

    context 'with activity params' do
      let(:args) { {name: 'An activity', start_time: 5.hours.from_now, end_time: 12.hours.from_now} }
      its(:name) { should == args[:name] }
      its(:start_time) { should == args[:start_time] }
      its(:end_time) { should == args[:end_time] }
    end
  end

  describe "#activity" do
    let(:activity) { OpenStruct.new  }
    let(:activity_id) { 1 }
    subject { event.activity(activity_id) }

    before do
      expect(event).to receive(:find_activity).with(activity_id).and_return(activity)
    end

    it { is_expected.to eq(activity) }
    its(:event) { should == event }
  end

  describe "#recent_activities" do
    let(:recent_activities) { [mock_model(Activity)] }
    subject { event.recent_activities }

    before do
      event.recent_activities_fetcher = ->{ recent_activities }
    end

    it { is_expected.to eq(recent_activities) }
  end

  describe "#all_activities" do
    let(:activities) { [double(:activity1), double(:activity2)] }
    let(:event) { Event.new }
    subject { event.activities }

    before do
      event.all_activities_fetcher = ->{ activities }
    end

    it { is_expected.to eq(activities) }
  end

  describe "#search_activities" do
    let(:activities) { [double(:activity1), double(:activity2)] }

    context "default args" do
      subject { event.search_activities }

      before do
        event.all_activities_fetcher = ->{ activities }
      end

      it { is_expected.to eq(activities) }
    end

    context "by name" do
      subject { event.search_activities(nil, "yummy", "all") }

      before do
        expect(Activity).to receive(:with_name_like).with("yummy").and_return(activities)
      end

      it { is_expected.to eq(activities) }
    end

    context "with filter" do
      let(:user) { mock_model(User) }
      subject { event.search_activities(user, "", filter) }

      context "owner" do
        let(:filter) { "owner" }

        before do
          expect(Activity).to receive(:all_activities).and_return(proxy)
          expect(proxy).to receive(:created_by).with(user).and_return(activities)
        end

        it { is_expected.to eq(activities) }
      end

      context "participant" do
        let(:filter) { "participant" }

        before do
          expect(Activity).to receive(:all_activities).and_return(proxy)
          expect(proxy).to receive(:participated_by).with(user).and_return(activities)
        end

        it { is_expected.to eq(activities) }
      end

      context "today" do
        let(:filter) { "today" }

        before do
          expect(Activity).to receive(:all_activities).and_return(proxy)
          expect(proxy).to receive(:today).and_return(activities)
        end

        it { is_expected.to eq(activities) }
      end

      context "wrong filter" do
        let(:filter) { "ownerx" }

        before do
          expect(Activity).to receive(:all_activities).and_return(activities)
        end

        it { is_expected.to eq(activities) }
      end

    end

  end

end
