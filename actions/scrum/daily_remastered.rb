require './voice'
require './will/personality'
require './senses/sight'
require_relative 'data_analytics'

# Formatting purposes
module ScrumMessage
  def self.format(answers)
    attachment = []
    colors = ['#e4dfdf', '#b4c7c5', '#488e96', '#e26f8e']
    questions = ['¿Cómo te sientes hoy?', '¿Qué hiciste ayer?', '¿Qué harás mañana?', '¿Algún inconveniente para ello?']
    questions.each_index do |i|
      attachment << {
        "author_name": (questions[i]).to_s,
        "color": (colors[i]).to_s,
        "text": (answers[i]).to_s
      }
    end
    attachment
  end

  def self.warning(text)
    attachment = [
      {
        "color": '#f40c0c',
        "text": text.to_s
      }
    ]
    attachment
  end
end

### SCRUM: add me --- Únete a la fiesta AGILE, es como el Lolla pero con coronas de Post-it.
module ScrumAdd
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    c = UserInfo.new(data.user, data)
    c.get_appearance
    ScrumGroup.create_user(data.user, c.slack_name)
    normal_talk('Agregado al EVASQUAD', data)
    event_look_revert
  end
end

### SCRUM: get my daily --- Muestrale a tus amigos y colaboradores más cercanos el equivalente de diario personal de tu día a día en el trabajo.
module ScrumRetrieve
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    answers, text = ScrumGroup.get_daily(data.user)
    if answers == []
      event_look_set('Angry Digital Expert', 'https://i.imgur.com/UwBWjtp.jpg')
      message = ScrumMessage.warning("¡<@#{data.user}> " + text)
      attachment_talk(message, data)
    else
      attach = ScrumMessage.format(answers)
      attachment_talk(attach, data)
    end
    event_look_revert
  end
end

### SCRUM: standup a < #public-channel > --- Define canal para publicar la daily. Default: '#hq-daily'.
module ScrumStandup
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')

    match = data.text.match(/standup\sa\s(\<[#@])?((.*)\|)?(.*?)(\>)/i)
    channel = 'hq-daily'
    channel = match.captures[2] || match.captures[3] unless match.nil?

    ScrumGroup.update_group(channel)
    normal_talk("Look At Me. I'm The Captain Now", channel)
    event_look_revert
  end
end

### SCRUM: daily start --- Digital Scrum master conversará contigo por interno y generará un reporte de daily con almacenado en Firestore.
module ScrumDaily2
  extend Voice
  extend Slack_history
  extend Persona

  def self.exec(data)
    emoji = %w[call_me_hand point_right spock-hand].sample
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    add_reaction(emoji, data.channel, data.ts)
    user = data.user
    dm = direct_talk(user)

    normal_talk("Buenos días <@#{user}>, ¿Te parece si empezamos con la daily?", dm)
    questions = ['¿Cómo te sientes hoy?', '¿Qué hiciste ayer?', '¿Qué harás mañana?', '¿Algún inconveniente para ello?']
    answers = []
    wait_time = 0.5
    questions.each do |line|
      normal_talk(line, dm)
      begin
        time = wait_time += 0.1
        sleep(time)
        text, full = last_message(1, dm, 'chat')
      end until full =~ /(#{user})/
      wait_time = 0.5
      answers << text
    end

    normal_talk("Excelente, gracias <@#{data.user}>", dm)
    ScrumGroup.save_daily(user, answers)
    responses, _text = ScrumGroup.get_daily(data.user)
    attach = ScrumMessage.format(responses)
    _time, _active, channel = ScrumGroup.get_group_info

    daily_date = Time.now.strftime('%d-%m')
    daily_channel = channel || '#hq-daily'

    update_message = responses.empty? ? "Agrego mi daily para hoy #{daily_date}." : "Actualizo mi daily, #{daily_date}."
    normal_talk('Estamos, gracias por tu tiempo.', data, data.ts)

    c = UserInfo.new(data.user, data)
    c.get_appearance
    event_look_set(c.slack_name, c.slack_image)
    normal_talk(update_message, daily_channel)
    attachment_talk(attach, daily_channel)
    event_look_revert
  end
end
