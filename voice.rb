require_relative 'mind/consciousness'
require_relative 'mind/judgment'

# Message methods
module Voice
  include Consciousness
  include Thought

  def normal_talk(text, data, ts = nil)
    client = configure_client
    discern_end(data, ts)
    client.web_client.chat_postMessage channel: @channel,
                                       text: text,
                                       icon_url: ENV['SLACK_BOT_ICON'],
                                       username: ENV['SLACK_BOT_NAME'],
                                       thread_ts: @thread
  end

  def attachment_talk(attachment, data, ts = nil)
    client = configure_client
    discern_end(data, ts)
    client.web_client.chat_postMessage channel: @channel,
                                       attachments: attachment,
                                       icon_url: ENV['SLACK_BOT_ICON'],
                                       username: ENV['SLACK_BOT_NAME'],
                                       thread_ts: @thread
  end

  def add_reaction(icon, channel, thread)
    client = configure_client('web')
    client.reactions_add channel: channel,
                         name: icon,
                         timestamp: thread,
                         icon_url: ENV['SLACK_BOT_ICON'],
                         username: ENV['SLACK_BOT_NAME']
  end

  def direct_talk(channel)
    client = configure_client('web')
    dm = client.conversations_open users: channel,
                                   icon_url: ENV['SLACK_BOT_ICON'],
                                   username: ENV['SLACK_BOT_NAME']
    dm.channel.id
  end
end
