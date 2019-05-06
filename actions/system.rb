require './voice'
require './senses/perception'

# When there's nothing to say, say the first thing that comes from your hash
module System_status
  extend Voice
  extend Temperature

  def self.exec(data)
    temperature = weather_report
    feeling = thermal_sensation_of(temperature)
    text = "I'm #{feeling}, it's #{temperature} outside"
    normal_talk(text, data)
  end
end

# Retrieve most recent timestamps of messages from specified channel. Options: channel, quantity (Default: 1 message), and channel type (groups or channels) (Default: channels)
module System_history
  def self.exec(text)
    text.match(/(#.*) (\n.*) (\w)/)
    last_message('#comunidad-seguridad')
  end
end

