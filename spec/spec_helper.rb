# frozen_string_literal: true

require 'envyable'

Envyable.load('config/env.yml', 'staging')

class DummyClass
end
