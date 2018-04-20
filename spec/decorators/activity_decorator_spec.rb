require 'rails_helper'

RSpec.describe ActivityDecorator do
  let (:activity) { build_stubbed(:activity, limit_of_participants: 20) }
  let (:decorator) { ActivityDecorator.new(activity) }

  describe '#spots_left' do
    subject { decorator.open_spots }

    before do
      allow(activity).to receive(:participations_count).and_return(count)
    end

    context 'no participants' do
      let(:count) { 0 }

      it { is_expected.to eq(20) }
    end

    context 'some participants' do
      let(:count) { 5 }

      it { is_expected.to eq(15) }
    end

    context 'too many participants' do
      let(:count) { 25 }

      it { is_expected.to eq(0) }
    end

    context "you're drunk Rails, go home!" do
      # it seems Rails counter caches return negative values sometimes
      let(:count) { -5 }

      it { is_expected.to eq(20) }
    end
  end

  describe '#formatted_time' do
    subject { decorator.formatted_time }

    before do
      allow(activity).to receive(:anytime?).and_return(anytime)
    end

    context 'with anytime set' do
      let(:anytime) { true }

      it { is_expected.to eq('Anytime') }
      it { is_expected.not_to be_html_safe }
    end

    context 'without anytime set' do
      let(:anytime) { false }

      it { is_expected.to eq('Thu 12 Dec / 18:00 &ndash; Fri 13 Dec / 03:00') }
      it { is_expected.to be_html_safe }
    end
  end
end
