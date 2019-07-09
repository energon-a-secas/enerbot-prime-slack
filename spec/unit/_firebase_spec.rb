# frozen_string_literal: true

require_relative '../spec_helper'
require './mind/memory'

describe '#FireDB' do
  context 'when updates' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(FireOps)
    end

    it { expect(@dummy_class.check_coins('rspec_user')).to eq 1 }
    it { expect(@dummy_class.update_coins('rspec_user', '++')).to eq 2 }
    it { expect(@dummy_class.update_coins('rspec_user', '--')).to eq 1 }
    it { expect(@dummy_class.update_coins('rspec_user', '++--')).to eq 1 }
    it { expect(@dummy_class.update_coins('rspec_user', 'asdasd')).to eq 1 }
    it { expect(@dummy_class.check_coins('rspec_user')).to eq 1 }
  end
end


