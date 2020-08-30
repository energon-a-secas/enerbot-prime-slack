require 'envyable'
require_relative 'main_threads'

Envyable.load('config/env.yml', 'production')
slack_spaces = ENV['SLACK_API_TOKENS']
e = MainThreads.new(slack_spaces)
e.run
