require './senses/sight'

# Module for regex and tests
module Vocal_Mimicry
  def coin_transaction(text)
    text.match(/^<@(.*?)>.*(\+\+|--|balance)(.*)/ix).try(:captures)
  end
end

module Conversation
  include Slack_history

  def dialog(user, pattern, max_time, channel, channel_type = 'chat')
    wait_time = 0.5
    begin
      time = wait_time += 0.1
      sleep(time)
      text, full = last_message(1, channel, channel_type)
      valid = true
      if time >= max_time
        valid = false
        break
      end
    end until text =~ /#{pattern}/ && full =~ /#{user}/
    [text, valid]
  end
end
