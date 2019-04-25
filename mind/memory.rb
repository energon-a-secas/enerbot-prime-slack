require 'mongo'

module Mongodb

  def add_document(knowledge, registry = '', coll = 'ai', database = 'experience')
    client = Mongo::Client.new(ENV['DATABASE_ADDRESS'], :database => database)
    collection = client[coll]
    doc = { registry => knowledge }
    result = collection.insert_one(doc)
    result.n
  end

  def delete_document(knowledge, registry, coll = 'rspec_coll', database = 'rspec_db')
    client = Mongo::Client.new(ENV['DATABASE_ADDRESS'], :database => database)
    collection = client[coll]
    result = collection.delete_one( { registry => knowledge} )
    result.deleted_count
  end

  def drop_collection(coll = 'rspec_coll', database = 'rspec_db')
    client = Mongo::Client.new(ENV['DATABASE_ADDRESS'], :database => database)
    collection = client[coll]
    collection.drop
  end

  def self.retrieve

  end

end