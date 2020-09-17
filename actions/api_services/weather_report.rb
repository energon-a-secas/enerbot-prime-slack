require 'open-uri'
require './lib/message_slack'

### ENERBOT: clima || clima en (*city*) --- Enerbot te dará el clima en Santiago
module WeatherReport
  extend MessageSlack

  def self.exec(data)
    text = data.text
    location = 'Santiago'
    if (match = text.match(/clima\s(.*?)$/i))
      location = match.captures[0].gsub('á', 'a')
    end
    html = open("https://wttr.in/#{location}?m", 'User-Agent' => 'curl/7.62.0').read
    weather = ''

    html.split(/\n/).each do |line|
      break if line =~ /\s+┌─────────────┐\s+/

      weather += line.gsub(/\[(\d+)?((;\d+)+)?(m)?/, '') + "\n"
    end

    message = weather.empty? ? 'Try another location' : weather
    send_message("```#{message}```", data)
  end
end
