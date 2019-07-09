# frozen_string_literal: true

require_relative '../spec_helper'
require './senses/sight'

describe '#See' do
  context 'when search on twitter' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(Lookup)
    end

    it { expect(@dummy_class.last_twitter('eneroffial')).to be_kind_of(String) }
  end
end
