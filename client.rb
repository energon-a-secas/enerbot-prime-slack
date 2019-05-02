require './main'
require 'envyable'

Envyable.load('config/env.yml', 'production')
Core.new