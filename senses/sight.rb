require 'twitter'
require './mind/conscious'

module Lookup
  def last_twitter(target)
    config = {
      consumer_key:        ENV['KEY'],
      consumer_secret:     ENV['KEY_KEY'],
      access_token:        ENV['TOKEN'],
      access_token_secret: ENV['TOKEN_KEY']
    }

    client = Twitter::REST::Client.new(config)

    result = ''
    client.search("to:#{target}", result_type: 'recent').take(3).each do |tweet|
      result = + "New tweet from #{tweet.user}: #{tweet.url}"
    end
    p result
  end
end

module Slack_history
  extend Conscious

  def last_message(type = 'channels', channel = '', messages = 1 )
    client = configure_client
    settings = [ channel: channel, count: messages ]
    response = case type
               when 'channels'
                 client.web_client.channels_history settings
               when 'groups'
                 client.web_client.groups_history settings
               end
    response.messages[0].ts
  end
end


