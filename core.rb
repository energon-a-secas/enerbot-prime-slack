require 'envyable'
require './mind/conscious'
require './directives'
require './voice'

# Eternal loop
class CL4P
  include Conscious
  include Voice

  def initialize
    client = configure_client
    log_channel = ENV['SLACK_LOG_CHANNEL']

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


Envyable.load('config/env.yml', 'production')
CL4P.new
