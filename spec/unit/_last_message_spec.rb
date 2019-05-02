require_relative '../spec_helper'
require './senses/sight'

describe '#Slack_history' do
  context 'when retrieve' do
    it { expect(Slack_history.last_message('#bot_monitoring', 1, 'groups')).to be_kind_of(String) }
  end

  context 'when fails' do
    it { expect(Slack_history.last_message('#fake_channel', 1, 'groups')).to eq 'Channel not found' }
  end
end
