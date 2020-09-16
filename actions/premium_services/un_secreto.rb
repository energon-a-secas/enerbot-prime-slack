require './lib/message_slack'
require './lib/client_slack'
require './lib/search_slack'
require './lib/image_slack'
require './lib/format_slack'

### HELP: secreto (channel_name|channel_id|channel_id-thread_timestamp|user_id) (*message*)
module PremiumSecret
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack
  extend SearchOnSlack

  def self.exec(data)
    if ENV['SLACK_PREMIUM_CLIENTS'].include? data.user
      event_look_set('E-Kun', 'https://i.imgur.com/P47Fazp.png')
      text = data.respond_to?(:text) ? data.text : data
      check = text.match(/(un secreto a|un secreto|secreto a|secreto)/)
      text = text.gsub(check[1], '') unless check.nil?
      text, channel, thread = channel_pattern(text)
      user_is_channel = get_user_id(channel)
      output = if user_is_channel == false
                 send_message(":see_no_evil: *Secreto:* #{text}", channel, thread)
               else
                 send_direct_message(text, channel)
               end
      event_look_revert
      output.message.text
    else
      send_message(['Lo siento no eres Premium', 'Pay2Win m8'].sample, data)
    end
  end
end
