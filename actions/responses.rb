require './voice'

# When there's nothing to say, say something
module Response_hi
  extend Voice
  def self.exec(data)
    text = 'holi'
    normal_talk(text, data)
  end
end
