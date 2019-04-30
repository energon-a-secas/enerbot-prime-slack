require 'slack-ruby-client'

module Conscious
  def configure_client(type = 'realtime', token = ENV['CL4P_API_TOKEN'])
    Slack.configure do |config|
      config.token = token
      config.raise 'Missing Bot token' unless config.token
    end

    case type
    when 'realtime'
      Slack::RealTime::Client.new
    when 'web'
      Slack::Web::Client.new
    end
  end
end
