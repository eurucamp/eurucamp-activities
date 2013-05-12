require 'spec_helper'

describe User do

  describe "validations" do

    subject { User.new }

    it { should     accept_values_for(:email, "xx@xx.com" ) }
    it { should_not accept_values_for(:email, "", nil, " x @ x.com", "123", "login@server." ) }

    it { should     accept_values_for(:password, "qweqweqwe" ) }
    it { should_not accept_values_for(:password, "qweqwe", nil, "") }

    it { should     accept_values_for(:name, nil, "", "Florian Gęga") }

  end

  describe "methods" do

    subject { FactoryGirl.create(:user) }

    it { should respond_to :activities }

  end

end
