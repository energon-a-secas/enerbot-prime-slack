require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/system'
require './actions/retrieve'

# Will does not refer to any particular desire, but rather to the mechanism for choosing from among one's directives.
class Directive

  def self.serve(data)
    func = { /eventos/ => System_status,
             /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song,
             /recomienda algo/ => Recommend_song,
             /beneficio/ => Retrieve_benefit,
             /fake status/ => Retrieve_status,
             /dame una excusa/ => Retrieve_excuse,
             /frase bronce/ => Retrieve_bronce,
             /dame un consejo/ => Retrieve_advice}
    text = data.text
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end
