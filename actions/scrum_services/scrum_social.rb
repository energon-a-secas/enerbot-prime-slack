require './lib/message_slack'
require './lib/image_slack'

# Say hi in the coolest way
### SCRUM: hola || hello --- Entrega un saludo de tu único e inigualable Digital Scrum Master.
module ScrumHi
  extend MessageSlack
  extend ImageSlack

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    text = ["Hello, <@#{data.user}>. Do you want a coffee?", '¿Qué onda, perrito? ¿Te vas a sumar a la daily?', 'Qué tal, chicos. Es hora de la daily.', 'Pibes, llegó la hora de las ceremonias. ¿Quién se anima a iniciar la daily, che?', 'Qué rico, buena onda. ¿Les parece si empezamos la daily?'].sample
    send_message(text, data)
    event_look_revert
  end
end

### SCRUM: hablame || saludame --- Ruega por un poco de la atención de tu Digital Scrum Master.
module ScrumDM
  extend MessageSlack
  extend ImageSlack

  def self.exec(data)
    text = "Hello, <@#{data.user}>. Do you want a coffee?"
    emoji = %w[call_me_hand point_right spock-hand].sample

    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    add_reaction(emoji, data.channel, data.ts)
    send_direct_message(text, data.user)
    event_look_revert
  end
end
