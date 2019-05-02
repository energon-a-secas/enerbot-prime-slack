require './mind/conscious'
require './mind/judgment'

USER_ICON = ENV['USER_ICON']
USER_NAME = ENV['USER_NAME']

# Message API
module Voice
  include Conscious
  include Thought

  def normal_talk(text, data)
    client = configure_client
    discern_end(data)
    client.web_client.chat_postMessage channel: @channel,
                                       text: text,
                                       icon_url: USER_ICON,
                                       username: USER_NAME,
                                       thread_ts: @thread
  end

  def add_reaction(text, data)
    client = configure_client('web')
    discern_end(data)
    client.reactions_add channel: @channel,
                         name: text,
                         timestamp: @thread,
                         icon_url: USER_ICON,
                         username: USER_NAME
  end
end
