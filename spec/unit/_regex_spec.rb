# frozen_string_literal: true

require_relative '../spec_helper'
require './actions/enercoins'

describe '#getData' do
  context 'when data is passed' do

    it { expect(get_values("<@rspec_test> ++ For testing")).to eq ['rspec_test', '++', ' For testing'] }
    it { expect(get_values("<@rspec_test> ++For testing")).to eq ['rspec_test', '++', 'For testing'] }
    it { expect(get_values("<@rspec_test>++For testing")).to eq ['rspec_test', '++', 'For testing'] }
    it { expect(get_values("<@rspec_test> ++ ")).to eq ['rspec_test', '++', ' '] }
    it { expect(get_values("<@rspec_test> --")).to eq ['rspec_test', '--', ''] }
    it { expect(get_values("<@rspec_test> balance ")).to eq ['rspec_test', 'balance', ' '] }
  end
end
