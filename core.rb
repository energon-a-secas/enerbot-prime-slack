require 'slack-ruby-client'
require './directives'
require './mind/conscious'
require './voice'

# Eternal loop
class CL4P
  include Conscious
  include Voice

  def initialize
    client = configure_client
    log_channel = '#bot_monitoring'

    client.on :hello do
      normal_talk('*Client connected*', log_channel)
    end

    client.on :message do |data|
      Directive.serve(data)
    end

    client.on :closed do |_data|
      normal_talk('*Client disconnected*', log_channel)
    end

    client.start!
  end
end

CL4P.new
