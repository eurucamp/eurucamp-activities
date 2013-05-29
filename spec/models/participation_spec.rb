require 'spec_helper'

describe Participation do

  describe "validations" do

    it { should     accept_values_for(:user_id, 1 ) }
    it { should_not accept_values_for(:user_id, "", nil) }

    it { should     accept_values_for(:activity_id, 1 ) }
    it { should_not accept_values_for(:activity_id, "", nil) }

    specify { FactoryGirl.create(:participation).clone.save! }.to raise(ActiveRecord::RecordInvalid)

  end

end
