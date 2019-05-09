require './mind/mood'
require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/system'
require './actions/retrieve'
require './actions/responses'
require './actions/search'

# Will does not refer to any particular desire,
# but rather to the mechanism for choosing from among one's directives.
class Directive
  extend Mood

  def self.check(data)
    bot_name = ENV['SLACK_BOT_NAME']
    text = data.text

    case text
    when /^\\/
      Directive.system(text, data)
    when /#{bot_name}/i
      thermal_impact
      Directive.serve(text, data)
    end
  end

  def self.serve(text, data)
    func = { /(hol[ai]|hello|hi)/ => ResponseHi,
             /hor[oó]scopo/i => SearchHoroscope,
             /(bail[ea]|directive three)/ => DiscoDance,
             /sismo/ => SearchEarthquakes,
             /pwned email/ => SearchHaveIBeen,
             /analiza/ => SearchWebSecurity,
             /canta/ => SingSong,
             /recomienda algo/ => RecommendSong,
             /beneficio/ => RetrieveBenefit,
             /dame una excusa/ => RetrieveExcuse,
             /frase bronce/ => RetrieveBronce,
             /dame un consejo/ => RetrieveAdvice }
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end

  def self.system(text, data)
    func = { /(hol[ai]|hello|hi)/ => SystemHi,
             /(events|eventos)/ => SystemStatus,
             /last message/ => SystemHistory,
             /(send)/ => SystemResp }
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end
