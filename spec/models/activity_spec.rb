require 'spec_helper'

describe Activity do

  let(:event) { mock(:event) }
  let(:creator) { User.new }
  subject(:activity) { Activity.new }

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
    let!(:recent_activities) { [mock(:activity1), mock(:activity2)] }
    subject { Activity.recent }

    before do
      Activity.stub_chain(:where, :limit).and_return(recent_activities)
    end

    it { should == recent_activities }
  end

  describe "#full_by" do
    subject { activity.full_by }

    context "limit of participants is not set" do
      before do
        activity.stub!(:limit_of_participants).and_return(nil)
      end

      it { should == 0 }
    end

    context "limit of participants is set" do
      before do
        activity.stub!(:limit_of_participants).and_return(10)
        activity.stub!(:participations_count).and_return(8)
      end

      it { should == 80 }
    end

    context "no participants" do
      before do
        activity.stub!(:limit_of_participants).and_return(10)
        activity.stub!(:participations_count).and_return(0)
      end

      it { should == 0 }
    end
  end

  describe "validations" do

    it { should     accept_values_for(:name, "Football game" ) }
    it { should_not accept_values_for(:name, "", nil) }
    #specify { FactoryGirl.create(:activity).clone.save! }.to raise(ActiveRecord::RecordInvalid)

    it { should     accept_values_for(:description, nil, "", "Wear some solid boots!")}

    it { should_not accept_values_for(:event, nil) }

    it { should     accept_values_for(:place, "football pitch" ) }
    it { should_not accept_values_for(:place, "", nil) }

    it { should     accept_values_for(:start_time, Time.now, nil) }
    it { should_not accept_values_for(:start_time, "") }

    it { should     accept_values_for(:end_time, Time.now, nil) }
    it { should_not accept_values_for(:end_time, "") }

    it { should     accept_values_for(:limit_of_participants, nil, 12, 100) }
    it { should_not accept_values_for(:limit_of_participants, -1, 0) }

  end

end
