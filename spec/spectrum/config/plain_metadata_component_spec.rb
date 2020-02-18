require_relative '../../spec_helper'
require 'spectrum/config/metadata_component'
require 'spectrum/config/plain_metadata_component'

describe Spectrum::Config::PlainMetadataComponent do
  subject { described_class.new('Name', {'type' => 'plain'}) }
  context "#resolve" do
    it "returns nil when given nil" do
      expect(subject.resolve(nil)).to be(nil)
    end

    it "returns nil when given []" do
      expect(subject.resolve([])).to be(nil)
    end

    it "returns nil when given [nil]" do
      expect(subject.resolve([''])).to be(nil)
    end

    it "returns nil when given ['']" do
      expect(subject.resolve([''])).to be(nil)
    end

    it "returns data when given true" do
      expect(subject.resolve(true)).to eq({term: 'Name', description: [{text: 'true'}]})
    end

    it "returns data when given false" do
      expect(subject.resolve(false)).to eq({term: 'Name', description: [{text: 'false'}]})
    end
  end
end