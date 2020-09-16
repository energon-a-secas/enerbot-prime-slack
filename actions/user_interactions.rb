require './lib/message_slack'
require './lib/format_slack'

### ENERBOT: elimina a (*@user1*) --- Ejecuta al usuario.
module UIDestroy
  extend MessageSlack
  extend FormatSlack
  def self.exec(data)
    user = data.user
    target_user = hyper_text_pattern(data.text)

    target = [user, target_user].sample
    text = ["Pium! #{target} :gun:", ":bomb: #{target_user}...\n\n\n :boom: :rainbow: ", "Un destino peor... te condeno a seguir viviendo #{target}"].sample
    send_message(text, data)
  end
end
