require './mind/memory'
require './voice'

module RetrieveBenefit
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_data('benefit', 'quotes')[:benefit]
    normal_talk(doc.sample, data)
  end
end

module RetrieveStatus
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_data('status', 'quotes')[:status]
    normal_talk(doc.sample, data)
  end
end

module RetrieveExcuse
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_data('excuse', 'quotes')[:excuse]
    normal_talk(doc.sample, data)
  end
end

module RetrieveBronce
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_data('bronze', 'quotes')[:bronze]
    normal_talk(doc.sample, data)
  end
end

module RetrieveAdvice
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_data('advice', 'quotes')[:advice]
    normal_talk(doc.sample, data)
  end
end
