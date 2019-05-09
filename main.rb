require './mind/conscious'
require './directives'
require './voice'

# Eternal loop
class Core
  include Conscious
  include Voice

  def initialize
    log_channel = ENV['SLACK_LOG_CHANNEL']

    client = configure_client

    client.on :hello do
      normal_talk('*Client connected*', log_channel)
    end

    client.on :message do |data|
      Directive.check(data)
    end

    client.on :closed do |_data|
      normal_talk('*Client disconnected*', log_channel)
    end

    client.start!
  end
end
