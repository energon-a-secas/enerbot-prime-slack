require_relative '../../../spec_helper'
require './actions/premium_functions/un_secreto'

describe PremiumSecret do
  describe '#exec' do
    let(:text) { 'Last message test' }
    let(:test_channel) { ENV['SLACK_TEST_CHANNEL'] }
    let(:fake_channel) { ENV['SLACK_FAKE_CHANNEL'] }
    let(:suffix) { ':see_no_evil: *Secreto:*' }

    context 'when succeeds' do
      it { expect(PremiumSecret.exec('secreto #general 1231 saludo')).to eq "#{suffix} 1231 saludo" }
      # it { expect(PremiumSecret.exec('secreto a #general <https:asdas|>')).to eq "#{suffix} <https:asdas|>" }
      it { expect(PremiumSecret.exec('un secreto #general !udo')).to eq "#{suffix} !udo" }
      it { expect(PremiumSecret.exec('un secreto a #general \!#as saludo')).to eq "#{suffix} \\!#as saludo" }
    end

    context 'when fails' do
    end
  end
end
