require 'spec_helper'

describe Activity do

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
      Activity.should_receive(:find_recent).and_return(recent_activities)
    end

    it { should == recent_activities }
  end

  describe "#limit_of_participants" do
    subject { activity.limit_of_participants }

    context "limit of participants is not set" do
      it { should == 10 }
    end
  end


  describe "#full_by" do
    subject { activity.full_by }

    context "limit of participants is not set" do
      before do
        activity.stub(:limit_of_participants).and_return(nil)
      end

      it { should == 0 }
    end

    context "limit of participants is set" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
        activity.stub(:participations_count).and_return(8)
      end

      it { should == 80 }
    end

    context "no participants" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
        activity.stub(:participations_count).and_return(0)
      end

      it { should == 0 }
    end
  end

  describe "#anybody_can_join?" do
    subject { activity.anybody_can_join? }

    context "no limit set" do
      before do
        activity.stub(:limit_of_participants).and_return(nil)
      end

      it { should == true }
    end

    context "limit set" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
      end

      it { should == false }
    end
  end

  describe "#today?" do
    subject { activity.today? }

    context "anytime set" do
      before do
        activity.stub(:anytime?).and_return(true)
      end

      it { should == true }
    end

    context "today" do
      before do
        activity.stub(:start_time).and_return(2.days.ago.to_time)
        activity.stub(:end_time).and_return(2.days.from_now.to_time)
      end

      it { should == true }
    end

    context "not today" do
      before do
        activity.stub(:anytime?).and_return(false)
        activity.stub(:start_time).and_return(2.days.from_now.to_time)
        activity.stub(:end_time).and_return(10.days.from_now.to_time)
      end

      it { should == false }
    end

  end

  describe "#full?" do
    subject { activity.full? }

    context "full" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
        activity.stub(:participations_count).and_return(10)
      end

      it { should == true }
    end

    context "too full" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
        activity.stub(:participations_count).and_return(11)
      end

      it { should == true }
    end

    context "not full" do
      before do
        activity.stub(:limit_of_participants).and_return(10)
        activity.stub(:participations_count).and_return(8)
      end

      it { should == false }
    end

  end

  describe "#upcoming?" do
    subject { activity.upcoming? }

    context "in the future" do
      before do
        activity.stub(:start_time).and_return(1.days.from_now.to_time)
      end

      it { should == true }
    end

    context "not in the future" do
      before do
        activity.stub(:start_time).and_return(Time.now)
      end

      it { should == false }
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
    it { should == new_participation }
  end

  describe "validations" do

    specify { expect { FactoryGirl.create(:activity).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

    it { should     accept_values_for(:name, "Football game" ) }
    it { should_not accept_values_for(:name, "", nil) }

    it { should     accept_values_for(:description, nil, "", "Wear some solid boots!")}

    it { should_not accept_values_for(:event, nil) }

    it { should     accept_values_for(:location, "football pitch" ) }
    it { should_not accept_values_for(:location, "", nil) }

    it { should     accept_values_for(:start_time, Time.now, nil) }

    it { should     accept_values_for(:end_time, Time.now, nil) }

    it { should     accept_values_for(:limit_of_participants, nil, 12, 100) }
    it { should_not accept_values_for(:limit_of_participants, -1, 0) }

    it { should     accept_values_for(:image_url, nil, "http://com.com/image.gif", "https://com.com/image.gif")  }
    it { should_not accept_values_for(:image_url, "http://com.co ge.gif", "ssh://com.com/image.gif", "blah")}

    context "invalid time frame (wrong order)" do
      subject { FactoryGirl.build(:activity, start_time: 10.days.ago.to_time, anytime: false) }

      it { should_not accept_values_for(:end_time, 15.days.ago.to_time) }
    end

    context "invalid time frame (out of scope)" do
      let(:event) { Event.new("A name", 2.days.ago.to_time, 2.days.from_now.to_time ) }
      subject { FactoryGirl.build(:activity, event: event, start_time: 10.days.ago.to_time, anytime: false) }

      it { should     accept_values_for(:start_time, 1.days.ago.to_time) }
      it { should_not accept_values_for(:start_time, 15.days.ago.to_time) }

      it { should     accept_values_for(:end_time, 1.days.from_now.to_time) }
      it { should_not accept_values_for(:end_time, 3.days.from_now.to_time) }
    end

  end

end
