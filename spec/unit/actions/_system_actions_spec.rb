require_relative '../../spec_helper'
require './lib/message_slack'
require './actions/system/system_actions'

describe SystemLastEvent do
  describe '#SystemLastEvent' do
    let(:text) { 'Last message test' }
    let(:test_channel) { ENV['SLACK_TEST_CHANNEL'] }
    let(:fake_channel) { ENV['SLACK_FAKE_CHANNEL'] }
    let(:slack) { DummyClass.new.extend(MessageSlack) }
    let(:message) { slack.send_message(text, test_channel).ok }

    context 'when succeeds' do
      it { expect(SystemLastEvent.exec("\\secho #{test_channel}").ok).to eql true }
      it { expect(SystemLastEvent.exec("\\secho #{test_channel} Custom message").ok).to eql true }
      it { expect(SystemLastEvent.exec("\\secho #{test_channel} :joy:").ok).to eql true }
      it { expect(SystemLastEvent.exec("\\sreact #{test_channel}").ok).to eql true }
      it { expect(SystemLastEvent.exec("\\sreact #{test_channel} :angry:").ok).to eql true }
    end
  end
end
