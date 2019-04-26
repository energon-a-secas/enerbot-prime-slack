require './mind/memory'
require './voice'

module Recite
  extend Mongodb
  extend Voice

  def self.benefit(data)
    benefits = retrieve('benefit', 'phrases', 'quote')
    normal_talk(benefits.sample, data)
  end
end
