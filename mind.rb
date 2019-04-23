# I would like to use it as a "sense"
module Conscious
  def configure_client(token = ENV['CL4P_API_TOKEN'])
    Slack.configure do |config|
      config.token = token
      config.raise 'Missing Bot token' unless config.token
    end

    @client = Slack::RealTime::Client.new
  end

  def space_perception # FIX THIS
    25
  end
end

# Base on the weather report, and should affect more actions than just the speed of response
module Mood
  extend Conscious
  @weather = space_perception

  def thermal_mood
    degrees = thermal_sensation_of(@weather)
    thermal_sensation_of(degrees)
  end

  def event_mood; end

  def thermal_sensation_of(degrees)
    mood = { 0..10 => 'freeze',
             11..19 => 'cold',
             20..27 => 'warm',
             28..33 => 'hot',
             34..37 => 'burn' }
    state = mood.select { |mood| mood === degrees }.values.first
    thermal_delay(state)
  end

  def thermal_delay(state)
    delay = { 'freeze' => 2,
              'cold' => 0.8,
              'warm' => 0.1,
              'hot' => 0.5,
              'burn' => 1 }
    sleep(delay[state].to_i)
  end
end

# Decisions
module Thought

  def discern_end(data)
    @thread = if data.respond_to? :thread_ts
                data.ts
              else
                ''
              end
    @channel = if data.respond_to? :channel
                 data.channel
               else
                 data
               end
  end
end

module Judgment # TODO
  extend Memory

  # State of Mood should only affect time to respond, at least for now
  energized || calm

  def initialize
    new = Mood.new
    # Should be the reasoning of a five years old
    it_must_be_done?
    it_should_be_done?
  end

  # Maybe return something or at least use a custom directive

  def when_it_should_be_done?; end
  def it_should_be_done?; end

  def it_must_be_done?; end
end

module Memory # TODO
  def declarative_memory
    # Things done AKA things that it learns
  end

  def non_declarative_memory
    # Things that it knows AKA Storage
  end
end

# Imagination
