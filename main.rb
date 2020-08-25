require './mind/consciousness'
require 'async/websocket/client'
require './directives'
require './voice'

# Eternal loop
class Core
  include Consciousness
  include Voice

  def initialize(token, log_channel = '#energon_logs')
    @token = token
    @channel = log_channel
  end

  def run
    $stdout.sync = true
    logger = Logger.new($stdout)
    logger.formatter = proc { |severity, datetime, _progname, msg| "[#{datetime}] #{severity} -- : #{msg}\n" }
    logger.level = Logger::DEBUG

    threads = []
    @token.split.each do |token|
      logger.info "Starting #{token[0..8]}(...)"
      client = configure_client('realtime', token)

      client.on :hello do |_data|
        logger.info("'#{client.self.name}' has connected to '#{client.team.name}' successfully")
      end

      client.on :message do |data|
        # logger.info(data)
        ENV['SLACK_API_TOKEN'] = token
        unless data.subtype == 'bot_message' && data.text.match('Ayuda')
          Directive.check(data)
        end
      end

      client.on :closed do |_data|
        normal_talk('*Client disconnected*', @channel)
      end

      threads << client.start_async
    end
    threads.each(&:join)
  end
end
