require_relative '../../spec_helper'
require 'spectrum/config/header_region'
require 'spectrum/config/header_component'
require 'spectrum/config/plain_header_component'


describe Spectrum::Config::HeaderRegion do
  subject { described_class.new('Name', region_config) }

  let(:region_config) {{ location: { 'type' => 'plain' } }}

  let(:data_input) {{
    term: 'TERM',
    description: 'DESCRIPTION',
  }}

  let(:data_output) { {} }
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
      expect(subject.resolve(data_input)).to eq(data_output)
    end
  end
end
