require 'slack-ruby-client'
require './soul'


# Obtains channel, thread, ts and attachments from incoming data
module Thought
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

# IT JUST WORKS
module Voice
  include Soul
  include Thought
  def normal_talk(text, data)
    configure_client
    select_end(data)
    @client.web_client.chat_postMessage channel: @channel,
                                        text: text,
                                        icon_url: 'http://www.fritzhardy.com/games/borderlands_2_ps3/E19655605689AC6A24D6C76039CF748B4493BA1B.PNG',
                                        username: 'CL4P-TP',
                                        thread_ts: @thread
  end
end
