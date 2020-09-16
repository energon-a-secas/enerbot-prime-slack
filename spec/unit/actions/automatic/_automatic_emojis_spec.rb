require_relative '../../../spec_helper'
require './actions/automatic_functions/emojis'

describe AutoEmoji do
  describe '#exec' do
    let(:text) { 'Last message test' }
    let(:test_channel) { ENV['SLACK_TEST_CHANNEL'] }
    let(:fake_channel) { ENV['SLACK_FAKE_CHANNEL'] }
    let(:slack) { DummyClass.new.extend(MessageSlack) }
    let(:message) { slack.send_message(text, test_channel).message }

    context 'when succeeds' do
      it { expect(AutoEmoji.exec('enerbot asado', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('enerbot @ @', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('@enerbot', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('#LosJuevesSonDeGlobant', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('Bienvenido', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('bienvenido', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('cerveza', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('Buenos días', test_channel, message.ts)).to be_a_kind_of Array }
    end

    context 'when fails' do
      # it { expect(AutoEmoji.exec('bienvenido <@12312312|test', test_channel, message.ts)).to eql nil }
      # it { expect(AutoEmoji.exec('\mode <@enerbot|test>', test_channel, message.ts)).to eql nil }
      #      it { expect(AutoEmoji.exec('@ @ @', test_channel, message.ts)).to be_a_kind_of Array }
      it { expect(AutoEmoji.exec('alguien esta viendo la tele?', test_channel, message.ts)).to eql nil }
      it { expect(AutoEmoji.exec('AdivinaA', test_channel, message.ts)).to eql nil }
      # it { expect(AutoEmoji.exec('adivinaalglober', test_channel, message.ts)).to eql nil }
    end
  end
end
