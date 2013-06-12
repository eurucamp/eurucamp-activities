require 'spec_helper'

describe Authentication do
  subject { Authentication.new }

  specify { expect { FactoryGirl.create(:activity).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

  it { should     accept_values_for(:user_id, 10) }
  it { should_not accept_values_for(:user_id, nil, "") }

  it { should     accept_values_for(:provider, "github", "twitter") }
  it { should_not accept_values_for(:provider, nil, "") }

  it { should     accept_values_for(:uid, "asd123dasd", "x") }
  it { should_not accept_values_for(:uid, nil, "") }
end