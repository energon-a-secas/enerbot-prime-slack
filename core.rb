require 'slack-ruby-client'
require './talk'
require './actions/idle'
require './actions/sing'
require './actions/dance'

# Base
class CL4P
  def initialize
    Slack.configure do |config|
      config.token = ENV['CL4P_API_TOKEN']
      config.raise 'Missing Bot token' unless config.token
    end

    client = Slack::RealTime::Client.new

    client.on :hello do
      Speech.normal("*Directive one:* Protect humanity!\n*Directive two:* Obey Lucio at all costs.\n*Directive three:* Dance!", '#bot_monitoring')
    end

    client.on :message do |data|
      channel = data.channel
      text = data.text

      case text
      # It should be something like if there aren't any events in 25 minutes, idle quote
      when /no eventos/
        Idle.quote(channel)
      when /(bail[ea]|directive three)/
        Dance.disco(channel)
      when /canta/
        Sing.song(channel)
      when /recomienda una canci[oó]n/
        Sing.recommend(channel)
      end
    end

    client.start!
  end
end

CL4P.new
