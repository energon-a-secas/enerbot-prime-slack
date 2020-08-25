require './mind/consciousness'

class UserInfo
  include Consciousness

  attr_accessor :slack_name, :slack_image

  def initialize(user, _data)
    @hook_client = configure_client('web')
    @user = user
  end

  def get_presence
    c = @hook_client.users_getPresence user: @user
    c.presence
  end

  def get_appearance
    c = @hook_client.users_info user: @user
    @slack_image = c.user.profile.image_512
    @slack_name = c.user.real_name
  end
end

module Slack_lookup
  include Consciousness

  def obtain_data_from(user)
    client = configure_client('web')
    c = client.users_info user: user
    [c.user.real_name, c.user.profile.image_512]
  end
end

module Slack_history
  include Consciousness

  def last_message(quantity = 10, channel = '#energon_logs', type = 'channel')
    client = configure_client
    begin
      response = case type
                 when 'channel'
                   client.web_client.channels_history channel: channel, count: quantity
                 when /(group|grp)/
                   client.web_client.groups_history channel: channel, count: quantity
                 when /chat/
                   client.web_client.conversations_history channel: channel, count: quantity
                 end

      times = quantity.to_i - 1
      text = ''
      full_data = ''
      0.step(times, 1) do |num|
        sms = response.messages[num]
        check_user = configure_client('web')
        human = ''
        begin
          if (match = sms.user.match(/(.*)/i))
            user = match.captures[0]
            search = check_user.users_info user: user
            human = search.user.real_name
          end
        rescue StandardError
          human = 'ENERBOT-R2'
        end
        text = sms.text
        unless sms.respond_to? :parent_user_id
          full_data << "[#{channel}-#{sms.ts}] *#{human}(#{user}):* #{sms.text}\n"
        end
      end
      [text, full_data]
    rescue Slack::Web::Api::Errors::SlackError => e
      print e
      "Channel not found #{channel}"
    end
  end
end
