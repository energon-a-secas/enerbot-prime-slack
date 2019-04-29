require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/report'
require './actions/retrieve'
require './senses/perception'
require './will/personality'

# Will does not refer to any particular desire, but rather to the mechanism for choosing from among one's directives.
class Directive
  extend Time_Space

  def self.check
    #check
    last_message
    #alternative
    Persona.alternative_answer
  end

  def self.serve(data)
    func = { /eventos/ => Report_status,
             /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song,
             /recomienda algo/ => Recommend_song,
             /beneficio/ => Retrieve_benefit }
    text = data.text
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end
