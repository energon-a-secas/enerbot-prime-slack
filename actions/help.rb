require './voice'

# When there's nothing to say, say the first thing that comes from your hash
module SystemHelp
  extend Voice

  def self.exec(data)
    text = ''
    normal_talk(text, data)
  end
end

module FunctionsHelp
  extend Voice

  def self.exec(data)
    text = "\\hola|hello|hi\n\\eventos|events\n\\last message\\send"
    normal_talk(text, data)
  end
end
