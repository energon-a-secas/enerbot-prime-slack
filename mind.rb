require './will'

# You know, because i like the Persona Franchise
module Conscious
  def configure_client(token = ENV['CL4P_API_TOKEN'])
    Slack.configure do |config|
      config.token = token
      config.raise 'Missing Bot token' unless config.token
    end

    @client = Slack::RealTime::Client.new
  end
end

# Decisions
module Thought
  # Obtains channel, thread, ts and attachments from incoming data
  def select_end(data)
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
  extend Mood
  extend Memory

  # State of Mood should only affect time to respond, at least for now
  energized || calm

  result = declarative_memory
  def it_should_be_done?(result); end
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
