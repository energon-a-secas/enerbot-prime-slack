require 'slack-ruby-client'
require './will'
require './mind'
require './voice'
require './actions/idle'
require './actions/sing'
require './actions/dance'

# Ears of Claptrap
class CL4P
  include Conscious
  include Voice

  def initialize

    configure_client

    @client.on :hello do
      normal_talk("*Directive one:* Protect humanity!\n*Directive two:* Obey Lucio at all costs.\n*Directive three:* Dance!", '#bot_monitoring')
    end

    @client.on :message do |data|
      Directive.serve(data)
    end

    @client.start!
  end
end

CL4P.new
