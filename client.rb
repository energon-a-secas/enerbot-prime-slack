require './main'
require 'envyable'

Envyable.load('config/env.yml', 'development')
Core.new