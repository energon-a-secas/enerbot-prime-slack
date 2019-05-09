require './voice'
require './senses/perception'
require './senses/sight'

# When there's nothing to say, say the first thing that comes from your hash
module System_status
  extend Voice
  extend Temperature

  def self.exec(data)
    temperature = weather_report
    feeling = thermal_sensation_of(temperature)
    text = "My system is #{feeling}, it's #{temperature} outside"
    normal_talk(text, data)
  end
end

# Retrieve most recent timestamps of messages from specified channel.
# Options: channel (Default: SLACK_BASE_CHANNEL), quantity (Default: 1 message), and channel type (groups or channels) (Default: channels)
module System_history
  extend Voice
  extend Slack_history

  def self.exec(data)
    timestamp = last_message('text')
    normal_talk(timestamp, data)
  end
end

module System_resp
  extend Voice

  def self.exec(data)
    match = data.text.match(/(\\send)\s(.*)\s(.*)/i)
    channel = match.captures[1]
    text = match.captures[2]
    normal_talk(text, channel)
  end
end

module System_hi
  extend Voice

  def self.exec(data)
    text = "Good morning, <@#{data.user}>. What will your first sequence of the day be?"
    normal_talk(text, data)
  end
end