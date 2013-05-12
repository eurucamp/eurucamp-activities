require 'spec_helper'

describe Activity do

  describe "validations" do

    subject { Activity.new }

    it { should     accept_values_for(:name, "Football game" ) }
    it { should_not accept_values_for(:name, "", nil) }
    specify { FactoryGirl.create(:activity).clone.save! }.to raise(ActiveRecord::RecordInvalid)

    it { should     accept_values_for(:description, nil, "", "Wear some solid boots!")}

    it { should     accept_values_for(:place, "football itch" ) }
    it { should_not accept_values_for(:place, "", nil) }

    it { should     accept_values_for(:start_at, Time.now) }
    it { should_not accept_values_for(:start_at, "", nil) }

    # whole day activity?
    it { should     accept_values_for(:time_frame, 15, 30, 60, 120, 360 ) } # minutes
    it { should_not accept_values_for(:time_frame, "", nil, 0, -10) }

    it { should     accept_values_for(:participants_limit, nil, 12, 100) }
    it { should_not accept_values_for(:participants_limit, -1, 0) }

  end

end