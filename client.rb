require './main'
require 'envyable'

Envyable.load('config/env.yml', 'production')
enerbot = Core.new(ENV['SLACK_API_TOKENS'])
enerbot.run
