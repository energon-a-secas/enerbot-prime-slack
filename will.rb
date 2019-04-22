require './mind'
# A forced will in a preemptible destiny
class Directive
  # Will does not refer to any particular desire, but rather to the mechanism for choosing from among one's directives.
  def initialize
    Mood.new
  end

  def self.serve(data)
    case data.text
    when /no eventos/
      Idle.quote(data)
    when /(bail[ea]|directive three)/
      Dance.disco(data)
    when /canta/
      Sing.song(data)
    when /recomienda una canci[oó]n/
      Sing.recommend(data)
    end
  end
end

# Ethics
# Patriarch

# Base on weather report
module Mood
  extend Conscious

  @weather = space_perception

  def initialize
    # Part of this should be done using eyes or more like senses
    is_a_good_temperature?(@weather)
  end

  def is_a_good_temperature?(degrees)
    mood = case degrees
           when (0..17)
             ''
           when (18..24)
             ''
           when (25..30)
             ''
           end

  end
end

# Personality
# Recanchero
