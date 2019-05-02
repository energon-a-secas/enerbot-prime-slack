require './mind/memory'
require './voice'

module Retrieve_benefit
  extend Mongodb
  extend Voice

  def self.exec(data)
    benefits = retrieve('benefit', 'phrases', 'quote')
    normal_talk(benefits.sample, data)
  end
end
