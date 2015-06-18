require 'rails_helper'

RSpec.describe ActivityDecorator do
  let (:activity) { FactoryGirl.build_stubbed(:activity, limit_of_participants: 20) }
  let (:decorator) { ActivityDecorator.new(activity) }

  describe "#spots_left" do
    subject { decorator.open_spots }

    before do
      allow(activity).to receive(:participations_count).and_return(count)
    end

    context "no participants" do
      let(:count) { 0 }

      it { is_expected.to eq(20) }
    end

    context "some participants" do
      let(:count) { 5 }

      it { is_expected.to eq(15) }
    end

    context "too many participants" do
      let(:count) { 25 }

      it { is_expected.to eq(0) }
    end

    context "you're drunk Rails, go home!" do
      # it seems Rails counter caches return negative values sometimes
      let(:count) { -5 }

      it { is_expected.to eq(20) }
    end
  end
end
