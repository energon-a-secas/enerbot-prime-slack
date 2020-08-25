require './voice'

### help: baila
module DiscoDance
  extend Voice
  def self.exec(data)
    text = ['https://youtu.be/KQbc2Mnb7pA'].sample
    normal_talk(text, data)
  end
end
