require_relative '../../spec_helper'
require_relative '../../config_stub'

require 'spectrum/config/field'
require 'spectrum/config/basic_field'
require 'spectrum/config/concat_field'

describe Spectrum::Config::ConcatField do
  context "#value" do

    context "When initialized without a join" do
      let(:args) { SpecData.load_json('args-002.json', __FILE__) }
      let(:config) { ConfigStub.new }
      let(:data) { { "title" => "TITLE", "subtitle" => "SUBTITLE" } }
      let(:result) { "TITLESUBTITLE" }
      subject { described_class.new(args, config) }

      it 'returns nil when called on nil' do
        expect(subject.value(nil, nil)).to eq(nil)
      end


      it "returns 'concatenated' values" do
        expect(subject.value(data, nil)).to eq(result)
      end
    end

    context "When initialized with a join" do
      let(:args) { SpecData.load_json('args-001.json', __FILE__) }
      let(:config) { ConfigStub.new }
      let(:data) { { "title" => "TITLE", "subtitle" => "SUBTITLE" } }
      let(:result) { "TITLE : SUBTITLE" }
      subject { described_class.new(args, config) }

      it 'returns nil when called on nil' do
        expect(subject.value(nil, nil)).to eq(nil)
      end

      it "returns 'concatenated' values" do
        expect(subject.value(data, nil)).to eq(result)
      end
    end

  end
end

