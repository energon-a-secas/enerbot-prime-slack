require_relative '../spec_helper'
require './mind/memory'

describe '#Mongodb' do
  context 'when logged' do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(Mongodb)
    end

    # There's a need for a double check whenever exists or not a collection
    it { expect(@dummy_class.add_document('One document', 'rspec_registry', 'rspec_coll', 'rspec_db')).to eq 1 }
    it { expect(@dummy_class.delete_document('One document', 'rspec_registry', 'rspec_coll', 'rspec_db')).to eq 1 }
    # TODO: Google how to evaluate this <Mongo::Operation::Result:
    # it { expect(@dummy_class.drop_collection('rspec_coll', 'rspec_db')).to be_a_kind_of(String)}
  end
end
