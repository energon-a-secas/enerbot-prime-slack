require './lib/message_slack'

### help: baila --- Regresará un baile con pantalla verde.
module DiscoDance
  extend MessageSlack
  def self.exec(data)
    # KQbc2Mnb7pA
    text = %w[m6k_t8yEyvE iG1o5xLqqcY IArX33Hoxog dlsjJ2xL0sw].sample
    url = 'https://youtu.be/' + text
    send_message(url, data)
  end
end
