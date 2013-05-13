require 'spec_helper'

describe Activity do

  let(:event) { mock(:event) }
  subject(:activity) { Activity.new }

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

  describe "validations" do

    it { should     accept_values_for(:name, "Football game" ) }
    it { should_not accept_values_for(:name, "", nil) }
    #specify { FactoryGirl.create(:activity).clone.save! }.to raise(ActiveRecord::RecordInvalid)

    it { should     accept_values_for(:description, nil, "", "Wear some solid boots!")}

    it { should     accept_values_for(:place, "football pitch" ) }
    it { should_not accept_values_for(:place, "", nil) }

    it { should     accept_values_for(:start_at, Time.now) }
    it { should_not accept_values_for(:start_at, "", nil) }

    # whole day activity?
    it { should     accept_values_for(:time_frame, 15, 30, 60, 120, 360 ) } # minutes
    it { should_not accept_values_for(:time_frame, "", nil, 0, -10) }

    it { should     accept_values_for(:limit_of_participants, nil, 12, 100) }
    it { should_not accept_values_for(:limit_of_participants, -1, 0) }

  end

end