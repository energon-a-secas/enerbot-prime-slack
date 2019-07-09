# frozen_string_literal: true

require './mind/consciousness'
require './mind/judgment'

# Message API
module Voice
  include Consciousness
  include Thought

  def normal_talk(text, data)
    client = configure_client
    discern_end(data)
    client.web_client.chat_postMessage channel: @channel,
                                       text: text,
                                       icon_url: ENV['SLACK_BOT_ICON'],
                                       username: ENV['SLACK_BOT_NAME'],
                                       thread_ts: @thread
  end

  def add_reaction(text, channel, thread)
    client = configure_client('web')
    client.reactions_add channel: channel,
                         name: text,
                         timestamp: thread,
                         icon_url: ENV['SLACK_BOT_ICON'],
                         username: ENV['SLACK_BOT_NAME']
  end
end
