# frozen_string_literal: true

require_relative '../spec_helper'
require './mind/judgment'

describe '#privileges_check' do
  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Security)
  end

  context 'when check' do
    it { expect(@dummy_class.privileges_check('normal_user')).to eq false }
    it { expect(@dummy_class.privileges_check('admin_user')).to eq true }
  end
end
