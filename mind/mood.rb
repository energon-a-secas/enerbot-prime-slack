# frozen_string_literal: true

require './senses/perception'

# Moody blues
module Mood
  include Temperature

  def thermal_impact
    state = thermal_sensation_of(weather_report)
    delay = thermal_delay(state)
    p "Report: my state is #{state} and gives me a delay of #{delay} seconds"
    sleep(delay)
  end

  def event_mood; end
end
