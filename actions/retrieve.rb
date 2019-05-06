require './mind/memory'
require './voice'

module Retrieve_benefit
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('benefit')
    normal_talk(doc.sample, data)
  end
end

module Retrieve_status
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('status')
    normal_talk(doc.sample, data)
  end
end

module Retrieve_excuse
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('excuse')
    normal_talk(doc.sample, data)
  end
end

module Retrieve_bronce
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('bronce')
    normal_talk(doc.sample, data)
  end
end

module Retrieve_advice
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('advice')
    normal_talk(doc.sample, data)
  end
end
