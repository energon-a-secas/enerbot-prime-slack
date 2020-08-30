require './lib/message_slack'

### help: baila
module DiscoDance
  extend MessageSlack
  def self.exec(data)
    text = ['https://youtu.be/KQbc2Mnb7pA'].sample
    send_message(text, data)
  end
end
