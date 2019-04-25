require 'slack-ruby-client'
require './mind/conscious'

# Message API
module Voice
  include Conscious
  include Thought

  def normal_talk(text, data)
    client = configure_client
    discern_end(data)
    client.web_client.chat_postMessage channel: @channel,
                                        text: text,
                                        icon_url: 'http://www.fritzhardy.com/games/borderlands_2_ps3/E19655605689AC6A24D6C76039CF748B4493BA1B.PNG',
                                        username: 'CL4P-TP',
                                        thread_ts: @thread
  end
end
