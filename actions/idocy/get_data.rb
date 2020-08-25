require 'google/cloud/firestore'

# Test ML for an weird AI
module LearnAnswer
  # Returns hash of q&a inside of a array of given path.
  def self.find_questions(doc)
    firestore = Google::Cloud::Firestore.new
    col_ref = firestore.col doc

    list = []
    col_ref.get do |doc|
      data = doc.data
      list << { data[:question] => data[:answer] } unless data[:question].nil?
    end
    list
  end

  # Removes words that are not that quite useful
  def self.filter_question(text)
    new_text = text
    simbolos = ['\?']
    call = ['sabes']
    pronombre_interrogativo = ['qu[eé]', 'quién', 'quiénes', 'cuál', 'cuáles', 'cuánto', 'cuánta', 'cuántos', 'cuántas', 'cuánto', 'cúyo', 'cúya', 'cúyos', 'cúyas']
    pronombres_objetos = ['t[uú]', 'usted', 'ustedes', 'vos', 'vosotros', 'te', 'ti', 'lo', 'la', 'le', 'os']
    preposiciones = ['a', 'ante', 'bajo', 'cabe', 'con', 'contra', 'de', 'desde', 'durante', 'en', 'entre', 'hacia', 'hasta', 'mediante', 'para', 'por', 'seg[uú]n', 'sin', 'so', 'sobre', 'tras', 'versus', 'v[ií]a']
    filtro = pronombre_interrogativo + pronombres_objetos + preposiciones + call
    filtro.each do |remove|
      new_text.gsub!(/\s#{remove}\s/, ' ')
    end
    simbolos.each do |remove|
      new_text.gsub!(/#{remove}/, '')
    end
    elements = new_text.split(' ')[1..-1]
    elements
  end

  # Checks match of concepts obtain by filter with the questions from Firestore
  def self.check_questions(list, question_pool)
    total = list.size
    response = []
    question_found = false
    question_pool.each do |qa|
      percent = 0
      question = ''
      answer = ''

      qa.each do |q, a|
        list.each do |data|
          check = q.match? /#{data}/
          next unless check

          percent += 1
          # else
          # print "\nMissing word: '#{data}'"
        end
        question = q
        answer = a
      end

      calc = percent.to_f / total.to_f * 100
      print "\nQuestion: '#{question}' [#{percent}/#{total} = #{calc}]\nAnswer: #{answer}\n"

      response << answer if calc >= 75.to_f
    end
    response
  end
end

# enerbot que le pasa a gcp?
# pasa gcp
# valida en pool de preguntas
# regresa pregunta(s) mas cercanas

# original = 'enerbot que le pasa a gcp?'
# frase = 'enerbot que le ocurre a jesus??'
# value = LearnAnswer.filter_question(frase)
# print "Searching for #{value} from question '#{original}'\n"

# pool = LearnAnswer.find_questions('ML/pronombres/qu[eé]/')
# answer, available = LearnAnswer.check_questions(value, pool)
# p answer
# p available
