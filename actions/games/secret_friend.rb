require './lib/message_slack'

### ENERBOT: amigo secreto (@user1) (@user2) --- Juego del amigo secreto para realizar de forma aleatoria tanto la distribución de regalos como el monto.
module SecretFriend
  extend MessageSlack
  def self.exec(data)
    text = data.text
    if (match = text.match(/amigo secreto (.*?)$/i))
      friends = match.captures[0]
    end
    friend_list = friends.split(',').shuffle
    message = 'La lista sigue así: '
    if friend_list.length > 2
      (0..(friend_list.length - 2)).each do |index|
        message += "*#{friend_list[index]}* regala a *#{friend_list[index + 1]}*, "
      end
      message += "*#{friend_list[friend_list.length - 1]}* regala a *#{friend_list[0]}*.\n"
      message += "Monto máximo sugerido para regalo: $#{rand(5_000..10_000)}"
    else
      message = 'Al menos deben ser 3 amigos... No creo que sea tan difícil ¿o no?'
    end

    send_message(message, data)
  end
end
