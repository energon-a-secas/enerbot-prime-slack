require './mind/memory'
require './voice'

module RetrieveBenefit
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('benefits')
    normal_talk(doc, data)
  end
end

# module RetrieveStatus
#   extend FirebaseOps
#   extend Voice
#
#   def self.exec(data)
#     doc = get_data('status', 'quotes')[:status]
#     normal_talk(doc.sample, data)
#   end
# end

module RetrieveExcuse
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('excuses')
    normal_talk(doc, data)
  end
end

module RetrieveBronce
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('bronzes')
    normal_talk(doc, data)
  end
end

module RetrieveAdvice
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('advices')
    normal_talk(doc, data)
  end
end
