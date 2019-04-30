require 'slack-ruby-client'
require './mind/conscious'
require './mind/judgment'

# Message API
module Voice
  include Conscious
  include Thought

  USER_ICON = 'http://www.fritzhardy.com/games/borderlands_2_ps3/E19655605689AC6A24D6C76039CF748B4493BA1B.PNG'
  USER_NAME = 'CL4P-TP'


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
