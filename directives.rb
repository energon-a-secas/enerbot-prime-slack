require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/system'
require './actions/retrieve'

# Will does not refer to any particular desire, but rather to the mechanism for choosing from among one's directives.
class Directive

  def self.listen(data)
    text = data.text
    case text
    when /^\\/
      Directive.serve(text, data)
    when /aigis/
      Directive.system(text, data)
    end
  end

  def self.serve(text, data)
    func = { /eventos/ => System_status,
             /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song,
             /recomienda algo/ => Recommend_song,
             /beneficio/ => Retrieve_benefit,
             /dame una excusa/ => Retrieve_excuse,
             /frase bronce/ => Retrieve_bronce,
             /dame un consejo/ => Retrieve_advice}
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end

  def self.system(text, data)
    func = { /(events|eventos)/ => System_status,
             /last message/ => System_history }
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end
