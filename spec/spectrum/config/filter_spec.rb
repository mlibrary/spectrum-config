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

      it "returns 'Yes' when given 'true'" do
        expect(subject.apply('true', nil)).to eq('Yes')
      end

      it "returns 'Yes' when given true" do
        expect(subject.apply(true, nil)).to eq('Yes')
      end

      it "returns 'Yes' when given 'yes'" do
        expect(subject.apply('yes', nil)).to eq('Yes')
      end

      it "returns nil when given 'false'" do
        expect(subject.apply('false', nil)).to be(nil)
      end

      it "returns nil when given false" do
        expect(subject.apply(false, nil)).to eq(nil)
      end

      it "returns nil when given 'no'" do
        expect(subject.apply('no', nil)).to eq(nil)
      end
    end
  end

end
