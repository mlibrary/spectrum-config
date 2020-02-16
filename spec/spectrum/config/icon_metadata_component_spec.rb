require_relative '../../spec_helper'
require 'spectrum/config/metadata_component'
require 'spectrum/config/icon_metadata_component'

describe Spectrum::Config::IconMetadataComponent do
  subject { described_class.new('Name', {'type' => 'icon'}) }

  context "#resolve" do
    it "returns nil when given nil" do
      expect(subject.resolve(nil)).to be(nil)
    end

    it "returns a text description when given true" do
      expect(subject.resolve(true)).to eq({term: 'Name', description: [{text: 'true'}]})
    end

    it "returns a text description when given false" do
      expect(subject.resolve(false)).to eq({term: 'Name', description: [{text: 'false'}]})
    end

    it "returns nil when given []" do
      expect(subject.resolve([])).to be(nil)
    end

    it "returns an icon  when given 'Book'" do
      expect(subject.resolve('Book')).to eq({term: 'Name', description: [{text: 'Book', icon: 'book'}]})
    end
  end
end
