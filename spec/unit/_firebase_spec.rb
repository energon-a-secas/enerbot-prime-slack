require_relative '../spec_helper'
require './mind/memory'

describe '#FireDB' do
  context 'when updates' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(FirebaseOps)
    end

    it { expect(@dummy_class.update_data('rspec_user', 2)).to eq true }
    it { expect(@dummy_class.check_account('rspec_user')).to eq 2 }
    it { expect(@dummy_class.update_data('rspec_user', -20)).to eq true }
    it { expect(@dummy_class.check_account('rspec_user')).to eq(-20) }
    it { expect(@dummy_class.update_data('rspec_user', 2)).to eq true }
  end
end
