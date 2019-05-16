require 'twitter'
require './mind/consciousness'

module Lookup
  def last_twitter(target)
    config = {
      consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
      access_token:        ENV['TWITTER_TOKEN_KEY'],
      access_token_secret: ENV['TWITTER_TOKEN_SECRET']
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
  include Consciousness

  def last_message(format = 'time', chan = ENV['SLACK_BASE_CHANNEL'], quantity = 1, type = 'channels')
    client = configure_client
    begin
      response = case type
                 when 'channels'
                   client.web_client.channels_history channel: chan, count: quantity
                 when 'groups'
                   client.web_client.groups_history channel: chan, count: quantity
                 end
      case format
      when 'text'
        response.messages[0].text
      when 'time'
        response.messages[0].ts
      end

    rescue Slack::Web::Api::Errors::SlackError => e
      print e
      "Channel not found #{chan}"
    end
  end
end
