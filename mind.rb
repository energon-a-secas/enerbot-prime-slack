require './senses/perception'

# Client initialization
module Conscious
  def configure_client(token = ENV['CL4P_API_TOKEN'])
    Slack.configure do |config|
      config.token = token
      config.raise 'Missing Bot token' unless config.token
    end

    @client = Slack::RealTime::Client.new
  end
end

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

# Selection that should be improved
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

class CriticalThinking
  def initialize(data)
    user = data.user
    text = data.text
    channel = data.channel

    register("#{user}, #{channel}: #{text}")
  end

  def register(*args)
    @var < args
  end

  def count_topics(*args)
    tokens = args.join(" ").split(/\s/)
    tokens.inject(Hash.new(0)) {|counts, token| counts[token] += 1; counts }
  end

  def popular_topics
    count_topics(@var)
  end
end

module Judgment # TODO

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
