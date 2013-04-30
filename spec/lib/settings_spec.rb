require 'spec_helper'

describe "Settings" do

  subject { Settings }

  its(:host) { should_not be_blank }
end