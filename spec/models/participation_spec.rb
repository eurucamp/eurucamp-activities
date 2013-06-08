require 'spec_helper'

describe Participation do

  describe "validations" do

    it { should     accept_values_for(:user_id, 1 ) }
    it { should_not accept_values_for(:user_id, "", nil) }

    it { should     accept_values_for(:activity_id, 1 ) }
    it { should_not accept_values_for(:activity_id, "", nil) }

    specify { expect { FactoryGirl.create(:participation).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

  end

end
