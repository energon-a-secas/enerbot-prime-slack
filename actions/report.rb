require './voice'
require './senses/perception'

# When there's nothing to say, say something
module Report
  extend Voice
  extend Temperature

  def self.status(data)
    temperature = weather_report
    feeling = thermal_sensation_of(temperature)
    text = "I'm #{feeling} because it's #{temperature} outside"
    normal_talk(text, data)
  end
end
