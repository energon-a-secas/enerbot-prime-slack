require './actions/idle'
require './actions/sing'
require './actions/dance'
require './actions/report'
require './actions/recite'

# Ethics
# Personality

class Directive
  # Will does not refer to any particular desire, but rather to the mechanism for choosing from among one's directives.

  def self.serve(data)
    meta = { /eventos/ => Report_status,
             /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song }
    regexp = data.text
    meta.keys.any? { |key| meta[key].exec(data) if key =~ regexp }
  end
end
