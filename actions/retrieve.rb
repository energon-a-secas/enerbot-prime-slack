require './mind/memory'
require './voice'

module RetrieveBenefit
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('benefit')
    normal_talk(doc.sample, data)
  end
end

module RetrieveStatus
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('status')
    normal_talk(doc.sample, data)
  end
end

module RetrieveExcuse
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('excuse')
    normal_talk(doc.sample, data)
  end
end

module RetrieveBronce
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('bronce')
    normal_talk(doc.sample, data)
  end
end

module RetrieveAdvice
  extend Mongodb
  extend Voice

  def self.exec(data)
    doc = retrieve('advice')
    normal_talk(doc.sample, data)
  end
end
