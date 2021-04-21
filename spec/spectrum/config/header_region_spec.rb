require_relative '../../spec_helper'
require 'spectrum/config/header_region'
require 'spectrum/config/header_component'
require 'spectrum/config/plain_header_component'


describe Spectrum::Config::HeaderRegion do
  subject { described_class.new('Name', region_config) }

  let(:region_config) {{ 'region_descriptor'=>{ 'type' => 'plain' } }}

  let(:data) {{
    term: 'TERM',
    description: 'DESCRIPTION',
  }}

  let(:data_result) {
    {
      description: "{:term=>\"TERM\", :description=>\"DESCRIPTION\"}",
      name: "Name",
      region: 'region_descriptor',
    }
  }

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

    it "returns data when given a data hash" do
      expect(subject.resolve(data)).to eq(data_result)
    end
  end
end
