require 'spec_helper'

describe Participation do

  describe "validations" do

    specify { expect { FactoryGirl.create(:participation).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

    it { should     accept_values_for(:user_id, 1 ) }
    it { should_not accept_values_for(:user_id, "", nil) }

    it { should     accept_values_for(:activity_id, 1 ) }
    it { should_not accept_values_for(:activity_id, "", nil) }

  end

end
