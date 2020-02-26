require_relative '../../spec_helper'

require 'spectrum/config/filter'

describe Spectrum::Config::Filter do

  context "Configured with boolean" do
    let(:cfg) {{'id' => 'boolean', 'method' => 'boolean'}}
    subject { described_class.new(cfg) }
    context "#apply" do
      it "returns nil when given nil" do
        expect(subject.apply(nil, nil)).to be(nil)
      end

      it "returns [] when given []" do
        expect(subject.apply([], nil)).to eq([])
      end

      it "returns 'yes' when given 'true'" do
        expect(subject.apply('true', nil)).to eq('yes')
      end

      it "returns 'yes' when given true" do
        expect(subject.apply(true, nil)).to eq('yes')
      end

      it "returns 'yes' when given 'yes'" do
        expect(subject.apply('yes', nil)).to eq('yes')
      end

      it "returns 'no' when given 'false'" do
        expect(subject.apply('false', nil)).to eq('no')
      end

      it "returns 'no' when given false" do
        expect(subject.apply(false, nil)).to eq('no')
      end

      it "returns 'no' when given 'no'" do
        expect(subject.apply('no', nil)).to eq('no')
      end
    end
  end

end
