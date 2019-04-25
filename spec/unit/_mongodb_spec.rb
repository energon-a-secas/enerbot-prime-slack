require_relative '../spec_helper'
require './mind/memory'

describe '#Mongodb' do
  context 'when add entries' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(Mongodb)
    end

    # There's a need for a double check whenever exists or not a collection
    it { expect(@dummy_class.add('Add one document', 'rspec_registry', 'rspec_coll', 'rspec_db')).to eq 1 }
    it { expect(@dummy_class.remove('Add one document', 'rspec_registry', 'rspec_coll', 'rspec_db')).to eq 1 }
  end
end
