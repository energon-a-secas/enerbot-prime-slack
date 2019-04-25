require 'slack-ruby-client'
require './will'
require './mind'
require './voice'
require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/report'
require './mind/conscious'

# Eternal loop
class CL4P
  include Conscious
  include Voice

  def initialize

    client = configure_client

    client.on :hello do
      # *Directive one:* Protect humanity!\n*Directive two:* Obey Lucio at all costs.\n*Directive three:* Dance!"
      normal_talk("*Client start*", '#bot_monitoring')
    end

    client.on :message do |data|
      Directive.serve(data)
    end

    client.on :closed do |_data|
      normal_talk("*Client disconnected*", '#bot_monitoring')
    end

    client.start!
  end
end

CL4P.new
