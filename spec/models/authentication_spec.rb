require 'spec_helper'

describe Authentication do
  subject { Authentication.new }

  specify { expect { FactoryGirl.create(:activity).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

  it { is_expected.to     accept_values_for(:user_id, 10) }
  it do
    skip "Currently Removed"
    # should_not accept_values_for(:user_id, nil, "") }
  end

  it { is_expected.to     accept_values_for(:provider, "github", "twitter") }
  it do
    skip "Currently Removed"
    # should_not accept_values_for(:provider, nil, "") }
  end

  it { is_expected.to     accept_values_for(:uid, "asd123dasd", "x") }
  it do
    skip "Currently Removed"
    # should_not accept_values_for(:uid, nil, "") }
  end
end
