require 'google/cloud/firestore'

# Modules for Firestore operations
module StoreSystem
  def new_client
    Google::Cloud::Firestore.new
  end

  def get_data(path, db)
    firestore = new_client
    document = firestore.doc "#{db}/#{path}"
    document.get
  end

  def get_col(collection)
    firestore = new_client
    quote_col = firestore.col(collection)
    quotes = []
    quote_col.get { |entry| quotes << entry[:texto] }
    quotes.sample
  end
end
