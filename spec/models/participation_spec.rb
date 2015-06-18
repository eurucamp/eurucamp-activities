require 'rails_helper'

describe Participation do

  describe "validations" do

    specify { expect { FactoryGirl.create(:participation).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

    it { is_expected.to     accept_values_for(:user_id, 1 ) }
    it { is_expected.not_to accept_values_for(:user_id, "", nil) }

    it { is_expected.to     accept_values_for(:activity_id, 1 ) }
    it { is_expected.not_to accept_values_for(:activity_id, "", nil) }

  end

end
