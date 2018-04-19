require 'rails_helper'

RSpec.describe Activity do

  let(:event) { double(:event) }
  let(:creator) { mock_model(User) }

  subject(:activity) { Activity.new }

  describe "#new" do
    its(:limit_of_participants) { should == 10 }
  end

  describe "#creator" do
    before do
      activity.creator = creator
    end

    its(:creator) { should == creator }
  end

  describe "#event" do
    before do
      activity.event = event
    end

    its(:event) { should == event }
  end

  describe ".recent" do
    let(:recent_activities) { [double(:activity1), double(:activity2)] }
    subject { Activity.recent }

    before do
      expect(Activity).to receive(:find_recent).and_return(recent_activities)
    end

    it { is_expected.to eq(recent_activities) }
  end

  describe "#limit_of_participants" do
    subject { activity.limit_of_participants }

    context "limit of participants is not set" do
      it { is_expected.to eq(10) }
    end
  end


  describe "#full_by" do
    subject { activity.full_by }

    context "limit of participants is not set" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(nil)
      end

      it { is_expected.to eq(0) }
    end

    context "limit of participants is set" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
        allow(activity).to receive(:participations_count).and_return(8)
      end

      it { is_expected.to eq(80) }
    end

    context "no participants" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
        allow(activity).to receive(:participations_count).and_return(0)
      end

      it { is_expected.to eq(0) }
    end
  end

  describe "#anybody_can_join?" do
    subject { activity.anybody_can_join? }

    context "no limit set" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(nil)
      end

      it { is_expected.to eq(true) }
    end

    context "limit set" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
      end

      it { is_expected.to eq(false) }
    end
  end

  describe "#today?" do
    subject { activity.today? }

    context "anytime set" do
      before do
        allow(activity).to receive(:anytime?).and_return(true)
      end

      it { is_expected.to eq(true) }
    end

    context "today" do
      before do
        allow(activity).to receive(:start_time).and_return(2.days.ago.to_time)
        allow(activity).to receive(:end_time).and_return(2.days.from_now.to_time)
      end

      it { is_expected.to eq(true) }
    end

    context "not today" do
      before do
        allow(activity).to receive(:anytime?).and_return(false)
        allow(activity).to receive(:start_time).and_return(2.days.from_now.to_time)
        allow(activity).to receive(:end_time).and_return(10.days.from_now.to_time)
      end

      it { is_expected.to eq(false) }
    end

  end

  describe "#full?" do
    subject { activity.full? }

    context "full" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
        allow(activity).to receive(:participations_count).and_return(10)
      end

      it { is_expected.to eq(true) }
    end

    context "too full" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
        allow(activity).to receive(:participations_count).and_return(11)
      end

      it { is_expected.to eq(true) }
    end

    context "not full" do
      before do
        allow(activity).to receive(:limit_of_participants).and_return(10)
        allow(activity).to receive(:participations_count).and_return(8)
      end

      it { is_expected.to eq(false) }
    end

  end

  describe "#upcoming?" do
    subject { activity.upcoming? }

    context "in the future" do
      before do
        allow(activity).to receive(:start_time).and_return(1.days.from_now.to_time)
      end

      it { is_expected.to eq(true) }
    end

    context "not in the future" do
      before do
        allow(activity).to receive(:start_time).and_return(Time.now)
      end

      it { is_expected.to eq(false) }
    end
  end

  describe "#new_participation" do
    let(:user) { mock_model(User) }
    let(:new_participation) { OpenStruct.new }
    let(:args) { {} }
    subject { activity.new_participation(user) }

    before do
      activity.participation_source = ->{ new_participation }
    end

    its(:participant) { should == user }
    its(:activity) { should == activity }
    it { is_expected.to eq(new_participation) }
  end

  describe '#dates' do
    context 'for an activity happening on a single day' do
      before do
        activity.start_time = Time.zone.local(2015, 7, 30, 10)
        activity.end_time = Time.zone.local(2015, 7, 30, 17)
      end

      it 'is the day of the activity' do
        expect(activity.dates).to eq([Date.new(2015, 7, 30)])
      end
    end

    context 'for an activity spanning multiple days' do
      before do
        activity.start_time = Time.zone.local(2015, 7, 30, 10)
        activity.end_time = Time.zone.local(2015, 8, 3, 9)
      end

      it 'is all the days the activity spans' do
        expect(activity.dates).to eq([
                                       Date.new(2015, 7, 30),
                                       Date.new(2015, 7, 31),
                                       Date.new(2015, 8, 1),
                                       Date.new(2015, 8, 2),
                                       Date.new(2015, 8, 3)
                                     ])
      end
    end
  end

  describe "validations" do
    it { is_expected.to     accept_values_for(:name, "Football game" ) }
    it { is_expected.not_to accept_values_for(:name, "", nil) }

    it { is_expected.to     accept_values_for(:description, nil, "", "Wear some solid boots!")}

    it { is_expected.not_to accept_values_for(:event, nil) }

    it { is_expected.to     accept_values_for(:location, "football pitch" ) }
    it { is_expected.not_to accept_values_for(:location, "", nil) }

    it { is_expected.to     accept_values_for(:start_time, Time.now) }

    it { is_expected.to     accept_values_for(:end_time, Time.now) }

    it { is_expected.to     accept_values_for(:limit_of_participants, nil, 12, 100) }
    it { is_expected.not_to accept_values_for(:limit_of_participants, -1, 0) }

    it { is_expected.to     accept_values_for(:image_url, nil, "http://com.com/image.gif", "https://com.com/image.gif")  }
    it { is_expected.not_to accept_values_for(:image_url, "http://com.co ge.gif", "ssh://com.com/image.gif", "blah")}

    context "invalid time frame (wrong order)" do
      subject { build(:activity, start_time: 10.days.ago.to_time, anytime: false) }

      it { is_expected.not_to accept_values_for(:end_time, 15.days.ago.to_time) }
    end

    context "invalid time frame (out of scope)" do
      let(:event) { Event.new("A name", 2.days.ago.to_time, 2.days.from_now.to_time ) }
      subject { build(:activity, event: event, start_time: 10.days.ago.to_time, anytime: false) }

      it { is_expected.to     accept_values_for(:start_time, 1.days.ago.to_time) }
      it { is_expected.not_to accept_values_for(:start_time, 15.days.ago.to_time) }

      it { is_expected.to     accept_values_for(:end_time, 1.days.from_now.to_time) }
      it { is_expected.not_to accept_values_for(:end_time, 3.days.from_now.to_time) }
    end

  end

end
