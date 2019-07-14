require_relative '../spec_helper'
require './senses/sight'

describe '#Slack_history' do
  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Slack_history)
  end

  context 'when retrieve' do
    it { expect(@dummy_class.last_message('text', '#bot_monitoring', 1, 'groups')).to be_kind_of(String) }
  end

  context 'when fails' do
    it { expect(@dummy_class.last_message('text', '#fake_channel', 1, 'groups')).to eq 'Channel not found #fake_channel' }
  end
end
