require 'rails_helper'

RSpec.describe 'validate FactoryBot factories' do
  FactoryBot.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      subject { FactoryBot.build(factory.name) }
      it { is_expected.to be_valid, subject.errors.full_messages.join(", ") }
    end
  end
end
