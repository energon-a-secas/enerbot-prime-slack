require './mind/conscious'
require './mind/judgment'

# Message API
module Voice
  include Conscious
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

  def add_reaction(text, data)
    client = configure_client('web')
    discern_end(data)
    client.reactions_add channel: @channel,
                         name: text,
                         timestamp: @thread,
                         icon_url: ENV['SLACK_BOT_ICON'],
                         username: ENV['SLACK_BOT_NAME']
  end
end
