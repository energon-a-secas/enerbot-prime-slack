require 'mongo'

# Memory long term
module Mongodb
  def new_client(database)
    Mongo::Logger.logger.level = ::Logger::FATAL
    Mongo::Client.new(ENV['DATABASE_ADDRESS'], database: database)
  end

  def add_document(knowledge, registry = '', coll = 'ai', db = 'experience')
    client = new_client(db)
    collection = client[coll]
    doc = { registry => knowledge }
    result = collection.insert_one(doc)
    result.n
  end

  def delete_document(knowledge, registry, coll = 'rspec_coll', db = 'rspec_db')
    client = new_client(db)
    collection = client[coll]
    result = collection.delete_one(registry => knowledge)
    result.deleted_count
  end

  def drop_collection(coll = 'rspec_coll', db = 'rspec_db')
    client = new_client(db)
    collection = client[coll]
    collection.drop
  end

  def list_collections(db = 'rspec_db')
    client = new_client(db)
    database = client.database
    database.collection_names
  end

  def retrieve(doc, coll = 'phrases', db = 'quote')
    client = new_client(db)
    document = client[coll].find.distinct(doc)
    p document
  end
end
