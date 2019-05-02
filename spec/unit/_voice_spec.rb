require_relative '../spec_helper'
require './voice'

describe '#Voice' do
  context 'when post succeed' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(Voice)
    end

    it { expect(@dummy_class.normal_talk('Rspec message', '#bot_monitoring').to(be_a_kind_of(Array))) }
  end
end
