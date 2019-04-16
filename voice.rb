require 'slack-ruby-client'
require './soul'

# IT JUST WORKS
module Voice
  include Soul
  def normal_talk(text, channel, thread = '')
    configure_client
    @client.web_client.chat_postMessage channel: channel,
                                        text: text,
                                        icon_url: 'http://www.fritzhardy.com/games/borderlands_2_ps3/E19655605689AC6A24D6C76039CF748B4493BA1B.PNG',
                                        username: 'CL4P-TP',
                                        thread_ts: thread
  end
end
