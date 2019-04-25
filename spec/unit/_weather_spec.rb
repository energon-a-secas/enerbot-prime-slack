require_relative '../spec_helper'
require './senses/perception'

describe '#Temperature' do
  context 'when thermal effect' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(Temperature)
    end

    it { expect(@dummy_class.weather_report).to be_kind_of(Numeric) }

    it { expect(@dummy_class.thermal_delay('extreme cold')).to eq 2 }

    it { expect(@dummy_class.thermal_sensation_of(22)).to eq 'warm' }
  end
end
