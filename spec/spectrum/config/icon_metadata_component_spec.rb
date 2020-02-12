require_relative '../../spec_helper'
require 'spectrum/config/metadata_component'
require 'spectrum/config/icon_metadata_component'

describe Spectrum::Config::IconMetadataComponent do
  subject { described_class.new('Name', {'type' => 'icon'}) }
  let(:data) { { 'icon' => 'ICON', 'text' => 'TEXT'} }
  context "#resolve" do
    it "returns nil when given nil" do
      expect(subject.resolve(nil)).to be(nil)
    end

    it "returns nil when given true" do
      expect(subject.resolve(true)).to be(nil)
    end

    it "returns nil when given false" do
      expect(subject.resolve(false)).to be(nil)
    end

    it "returns nil when given []" do
      expect(subject.resolve([])).to be(nil)
    end

    it "returns a link when given data" do
      expect(subject.resolve(data)).to eq({term: 'Name', description: [{text: 'TEXT', icon: 'ICON'}]})
    end
  end
end
