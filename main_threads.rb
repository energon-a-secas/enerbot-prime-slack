require 'async/websocket/client'
require_relative 'directives'
require_relative 'lib/client_slack'
require_relative 'lib/message_slack'

# Initialization of multiple clients on different threads based on array of tokens
class MainThreads
  include ClientSlack
  include MessageSlack

  def initialize(token, log_channel = '#hq-t-scl-development-logs')
    @token = token
    @channel = log_channel
  end

  def run
    threads = []
    @token.split.each do |token|
      client = configure_client('realtime', token)

      client.on :hello do
        puts "Successfully connected '#{client.self.name} to the '#{client.team.name}'"
      end

      client.on :message do |data|
        ENV['SLACK_API_TOKEN'] = token
        Directive.check(data) unless data.subtype == 'bot_message' && data.text.match('Ayuda')
      end

      client.on :closed do |_data|
        ENV['SLACK_API_TOKEN'] = token
        send_message('*Client disconnected*', @channel)
      end

      threads << client.start_async
    rescue Slack::Web::Api::Errors::AccountInactive => e
      puts "#{e.message}: #{token}"
    end
    threads.each(&:join)
  end
end
