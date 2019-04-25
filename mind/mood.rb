require './senses/perception'

# Moody blues
module Mood
  extend Temperature
  @weather = weather_report

  def thermal_mood
    state = thermal_sensation_of(@weather)
    delay = thermal_delay(state)
    sleep(delay)
  end

  def event_mood; end
end
