require_relative '../spec_helper'
require './mind/language'

describe '#coin_transaction' do
  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Vocal_Mimicry)
  end

  context 'when data is passed' do
    it { expect(@dummy_class.coin_transaction('<@rspec_test> ++ For testing')).to eq ['rspec_test', '++', ' For testing'] }
    it { expect(@dummy_class.coin_transaction('<@rspec_test> ++For testing')).to eq ['rspec_test', '++', 'For testing'] }
    it { expect(@dummy_class.coin_transaction('<@rspec_test>++For testing')).to eq ['rspec_test', '++', 'For testing'] }
    it { expect(@dummy_class.coin_transaction('<@rspec_test> ++ ')).to eq ['rspec_test', '++', ' '] }
    it { expect(@dummy_class.coin_transaction('<@rspec_test> --')).to eq ['rspec_test', '--', ''] }
    it { expect(@dummy_class.coin_transaction('<@rspec_test> balance ')).to eq ['rspec_test', 'balance', ' '] }
  end
end
