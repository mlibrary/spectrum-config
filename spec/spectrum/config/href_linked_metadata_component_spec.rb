require_relative '../../spec_helper'
require 'spectrum/config/metadata_component'
require 'spectrum/config/href_linked_metadata_component'

describe Spectrum::Config::HrefLinkedMetadataComponent do
  subject { described_class.new('Name', {'type' => 'href_linked'}) }
  let(:data) { { 'href' => 'HREF', 'text' => 'TEXT'} }
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
      expect(subject.resolve(data)).to eq({term: 'Name', description: [{text: 'TEXT', href: 'HREF'}]})
    end
  end
end
