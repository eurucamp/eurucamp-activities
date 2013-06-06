require 'spec_helper'

describe "Settings" do

  subject { Settings }

  its(:host) { should_not be_blank }
  its(:event) { should_not be_blank }

  describe "#event" do

    subject { Settings.event }

    its(:name)       { should_not be_blank }
    its(:start_time) { should be_a_kind_of(Time) }
    its(:end_time)   { should be_a_kind_of(Time) }

  end

end