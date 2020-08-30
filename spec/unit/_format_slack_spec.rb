require './spec/spec_helper'
require './lib/format_slack'

describe FormatSlack do
  describe '#get_values_from' do
    let(:text) { 'Hola <@LUC14AN>' }
    let(:fake_text) { 'Hola humano' }
    let(:dc) { DummyClass.new.extend(FormatSlack) }

    context 'when match succeeds' do
      it { expect(dc.get_values_from(text).captures[0]).to eq('LUC14AN') }
    end

    context 'when match fails' do
      it { expect(dc.get_values_from(fake_text)).to be nil }
      it { expect(dc.get_values_from(fake_text).respond_to?(:captures)).to be false }
    end
  end

  describe '#process_data' do
    let(:dc) { DummyClass.new.extend(FormatSlack) }

    context 'when match succeeds' do
      it { expect(dc.process_data('\echo #comunidad-seguridad un saludo')).to eq(['un saludo', '#comunidad-seguridad', nil]) }
      it { expect(dc.process_data('\echo #comunidad-seguridad 1231 saludo')).to eq(['1231 saludo', '#comunidad-seguridad', nil]) }
      it { expect(dc.process_data('\echo #comunidad-seguridad \!#as saludo')).to eq(['\!#as saludo', '#comunidad-seguridad', nil]) }
      it { expect(dc.process_data('\echo <@LUC14AN|Lucio> un saludo')).to eq(['un saludo', 'LUC14AN', nil]) }
      it { expect(dc.process_data('\echo LUC14AN un saludo')).to eq(['un saludo', 'LUC14AN', nil]) }
      it { expect(dc.process_data('\echo CH4NN3L-1588015518.007300 un saludo')).to eq(['un saludo', 'CH4NN3L', '1588015518.007300']) }
    end

    context 'when match fails' do
      # it { expect(dc.echo('\echo #comunidad-seguridadun saludo')).to eq(['saludo', '#comunidad-seguridadun', nil]) }
    end
  end
end

# require_relative '../spec_helper'
# require './mind/language'
#
# describe '#coin_transaction' do
#   before(:each) do
#     @dummy_class = DummyClass.new
#     @dummy_class.extend(Conversation)
#   end
#
#   context 'when data is passed' do
#     it { expect(@dummy_class.coin_transaction('<@rspec_test> ++ For testing')).to eq ['rspec_test', '++', ' For testing'] }
#     it { expect(@dummy_class.coin_transaction('<@rspec_test> ++For testing')).to eq ['rspec_test', '++', 'For testing'] }
#     it { expect(@dummy_class.coin_transaction('<@rspec_test>++For testing')).to eq ['rspec_test', '++', 'For testing'] }
#     it { expect(@dummy_class.coin_transaction('<@rspec_test> ++ ')).to eq ['rspec_test', '++', ' '] }
#     it { expect(@dummy_class.coin_transaction('<@rspec_test> --')).to eq ['rspec_test', '--', ''] }
#     it { expect(@dummy_class.coin_transaction('<@rspec_test> balance ')).to eq ['rspec_test', 'balance', ' '] }
#   end
# end
