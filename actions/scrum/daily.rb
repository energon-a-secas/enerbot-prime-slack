require './voice'
require './senses/sight'
require './mind/consciousness'
require './will/personality'

# Say hi in the coolest way
### SCRUM: hola || hello || hi --- Entrega un saludo de tu único e inigualable Digital Scrum Master.
module ScrumHi
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    text = ["Hello, <@#{data.user}>. Do you want a coffee?", '¿Qué onda, perrito? ¿Te vas a sumar a la daily?', 'Qué tal, chicos. Es hora de la daily.', 'Pibes, llegó la hora de las ceremonias. ¿Quién se anima a iniciar la daily, che?', 'Qué rico, buena onda. ¿Les parece si empezamos la daily?'].sample
    normal_talk(text, data)
    event_look_revert
  end
end

### SCRUM: hablame || saludame --- Ruega por un poco de la atención de tu Digital Scrum Master.
module ScrumDirect
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    add_reaction(%w[call_me_hand point_right spock-hand].sample, data.channel, data.ts)
    text = "Hello, <@#{data.user}>. Do you want a coffee?"
    channel = data.user
    dm = direct_talk(channel)
    normal_talk(text, dm)
    event_look_revert
  end
end

### SCRUM: group info --- Obtiene información como horario de dailies.
module ScrumInfo
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    time, _active, _channel = ScrumGroup.get_group_info
    text = "Información sobre el *EVASQUAD*:\n:bookmark: *Descripción:* 'en el backlog'.\n:timer_clock: *Horario de Daily:* #{time} horas.\n:two_hearts: *Grupo activo:* si."
    normal_talk(text, data)
    event_look_revert
  end
end

### SCRUM: members || miembros --- Entraga listado de miembros pertenecientes a una célula/team/cofradía.
module ScrumMembers
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    text = ScrumGroup.get_members
    normal_talk(text, data)
    event_look_revert
  end
end

### SCRUM: ensayo --- Digital Scrum master conversará contigo por interno y generará un reporte de daily sin almacenarlo en Firestore.
module ScrumDaily
  extend Voice
  extend Slack_history
  extend Persona

  def talk(chat, data)
    chat.each_line do |line|
      sleep(1)
      normal_talk(line, data)
    end
  end

  def self.exec(data)
    emoji = %w[call_me_hand point_right spock-hand].sample
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    add_reaction(emoji, data.channel, data.ts)
    channel = data.user
    dm = direct_talk(channel)

    normal_talk("Buenos días <@#{data.user}>, ¿Te parece si empezamos con la daily?", dm)
    colors = ['#e4dfdf', '#b4c7c5', '#488e96', '#e26f8e']
    questions = ['¿Cómo te sientes hoy?', '¿Qué hiciste ayer?', '¿Qué harás mañana?', '¿Algún inconveniente para ello?']
    sleep(2)
    answers = []
    questions.each do |line|
      sleep(1)
      normal_talk(line, dm)
      p data
      begin
        text, full = last_message(1, dm, 'chat')
        sleep 1
      end until full =~ /(#{data.user})/
      answers << text
    end
    c = UserInfo.new(data.user, data)
    c.get_appearance
    event_look_set(c.slack_name, c.slack_image)
    daily_update = "Daily de #{username}, #{Time.now.strftime('%d-%m-%y')}"
    attachment = []
    questions.each_index do |i|
      attachment << {
        "author_name": (questions[i]).to_s,
        "color": (colors[i]).to_s,
        "text": (answers[i]).to_s
      }
    end
    normal_talk(daily_update, data.channel)
    attachment_talk(attachment, data.channel)
    event_look_revert
  end
end
