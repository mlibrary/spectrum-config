require_relative '../../spec_helper'
require 'spectrum/config/metadata_component'
require 'spectrum/config/search_metadata_component'

describe Spectrum::Config::SearchMetadataComponent do
  subject { described_class.new('Name', config) }
  let(:config) {{
    'scope' => 'SCOPE',
    'search_type' => 'filtered',
    'text_field' => 'text',
    'value_field' => 'value',
  }}
  let(:data) {{
    'text' => 'TEXT',
    'value' => 'VALUE',
  }}

  let(:result) {{
    term: 'Name',
    description: [{
      text: 'TEXT',
      search: {
        type: 'filtered',
        scope: 'SCOPE',
        value: 'VALUE',
      }
    }],
  }}
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
      expect(subject.resolve(data)).to eq(result)
    end
  end
end
