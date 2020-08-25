require 'google/cloud/firestore'

module CreateAnswer
  def generate_code(number)
    charset = Array('A'..'Z') + Array('a'..'z')
    Array.new(number) { charset.sample }.join
  end

  # Create data
  def set_collection(path, question, answer)
    doc_id = generate_code(20)
    firestore = Google::Cloud::Firestore.new
    intention = firestore.doc "#{path}/#{doc_id}"
    data = {
      question: question,
      answer: answer
    }
    intention.set data
    print "Data set for #{doc_id} on '#{path}'."
  end

  def create_collections
    ['qui[eé]n', 'qu[eé]', 'cu[aá]ndo', 'd[oó]nde'].each do |v|
      LearnAnswer.set_collection(v)
    end
  end
end
