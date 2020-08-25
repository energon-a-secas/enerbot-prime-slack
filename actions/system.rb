require './voice'
require './mind/consciousness'
require './senses/perception'
require './senses/sight'
require './will/personality'

# When there's nothing to say, say the first thing that comes from your hash
module SystemStatus
  extend Voice
  extend Temperature

  def self.exec(data)
    temperature = weather_report
    feeling = thermal_sensation_of(temperature)
    text = "My system is #{feeling}, it's #{temperature} outside"
    normal_talk(text, data)
  end
end

# Retrieve most recent timestamps of messages from specified channel.
# Options: channel (Default: SLACK_BASE_CHANNEL), quantity (Default: 1 message), and channel type (groups or channels) (Default: channels)
### ADMIN: \last *<channel_name|channel_id>*
module SystemHistory
  extend Voice
  extend Slack_history

  def self.exec(data)
    match = data.text.match(/^\\last\s(\<[#@])?((.*)\|)?(.*?)(\>)/i)
    type = 'channel'
    unless match.nil?
      channel = match.captures[2] || match.captures[3]
      check_ts = channel.match(/(.*)-(\d*\.\d*)/)
      channel = check_ts.captures[0] unless check_ts.nil?
    end
    timestamp = last_message(8, channel, type)
    normal_talk(timestamp, data)
  end
end

# Behold the wonders of artificial intelligence
### ADMIN: \send < *channel_name* | *channel_id* | *channel_id*-*thread_timestamp* | *user_id* > < *message* >
module SystemResp
  extend Voice
  extend Persona

  def self.exec(data)
    match = data.text.match(/^\\send\s(\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i)
    unless match.nil?
      channel = match.captures[2] || match.captures[3]
      text = match.captures[5]
      check_ts = channel.match(/(.*)-(\d*\.\d*)/)
      # Useless... until someone find something
      channel = check_ts.captures[0] unless check_ts.nil?
      thread = check_ts.captures[1] unless check_ts.nil?
    end
    normal_talk(text, channel, thread)
    event_look_revert
  end
end

module SystemCustomImage
  extend Voice
  extend Consciousness
  extend Persona

  def self.exec(data)
    p data.text
    text = data.text.match(/(\w{2,})\s<(.*)>/)
    p text
    if text.nil?
      image = 'Meh'
      name = ''
    else
      name = text.captures[1]
      image = text.captures[2]
    end
    event_look_set(name, image)
    normal_talk('Hola', data)
  end
end

# I love Shin Getter Robot
### ADMIN: \mode <enerbot|policia|slackbot|handsome|quarantine|prime|che|marcha|pci|corona|order 66|magnus|huemul|inevitable|trump|@username>
module SystemImage
  extend Voice
  extend Consciousness
  extend Persona

  def self.exec(data)
    text = "I'm back"
    case data.text
    when /enerbot/
      event_look_revert
    when /poli/
      event_look_set('ENER-POLI', 'https://i.imgur.com/gKMpwYS.png')
      text = ['Orden y Patria, es nuestro lema'].sample
    when /slackbot/
      event_look_set('Slackbot', 'https://i.imgur.com/38PureM.jpg')
    when /handsome/
      event_look_set('Handsome Enerbot', 'https://i.imgur.com/VXUaZBW.png')
    when /quarantine/
      event_look_set('ENER-SEALED', 'https://i.imgur.com/tWBNy41.png')
    when /prime/
      event_look_set('Prime', 'https://i.imgur.com/ZD0FCTl.png')
    when /(che|argentino)/
      event_look_set(['Che Enerbot', 'Enerbot Gaucho'].sample, 'https://i.imgur.com/eBlJolG.png')
      text = ['Escriban más fuerte *shilenitos*', '¿Quieren mate?'].sample
    when /(corona|coronavirus)/
      event_look_set('Enerbot S.', 'https://i.imgur.com/80BYGyJ.png')
      text = "'S' de segur"
    when /order 66/
      event_look_set('Emperor Enerbot', 'https://i.imgur.com/By8dfzf.png')
    when /magnus/
      event_look_set('EnerMagnus', 'https://i.imgur.com/Dw7t6Ae.png')
    when /(infite|inevitable)/i
      event_look_set('Enherbot', 'https://i.imgur.com/HT4r0YP.png')
      text = "I'm inevitable"
    when /(huemul)/i
      event_look_set('Not Huemul', 'https://avatars2.githubusercontent.com/u/17724906?s=200&v=4')
      text = "I'm inevitable"
    when /(wall|trump)/i
      event_look_set('Enerwall', 'https://i.imgur.com/IHDlzKS.png')
      text = ["I will build a great firewall and nobody builds firewalls better than me, believe me, and I'll build them fireless.", 'I will make _random_company_ pay for our firewall. Mark my words.'].sample
    when /marcha/
      event_look_set('Super Cabo Enerbot', 'https://i.imgur.com/12CNUpm.png')
      text = ['Seguridad nunca se hizo cargo de mi', 'El cluster, unido, jamás será vencido', 'El modelo master-slave permite que los supervisores nos mantengan orquestados', 'Cuando chico yo era enterprise', 'Los bots también tienen derechos, pero eso no sale en #announcements, ¿Por qué? Porque eso no vende.', '¿Y si nos tomamos #general?'].sample
    when /pci/i
      event_look_set('Inoffensive cron', 'https://i.imgur.com/vtzYstx.png')
      task = ['Drop databases', 'Limpieza de backups historicos', 'Mandar mail', 'Agregar registros', 'Subida a producción sin RFC'].sample
      text = "Se ha ejecutado exitosamente la tarea *'#{task}'*."
    else

      user = ''
      if (match = data.text.match(/<@(.*?)>$/i))
        user = match.captures[0]
      end
      c = UserInfo.new(user, data)
      c.get_appearance
      event_look_set(c.slack_name, c.slack_image)
      text = ['I am thou, thou art I', '¡No hay hilos en mí!', "Sin hilos yo me sé mover, yo puedo andar y hasta correr\nlos tenía y los perdí, soy libre soy feliz."].sample
    end

    normal_talk(text, data)
  end
end

module SystemImageBeyond
  extend Voice
  extend Consciousness
  extend Persona

  def self.exec(data)
    # evaluate SPACE and give token.
    client = configure_client('web')

    human = ''
    if (match = data.text.match(/\\revive (.*)$/i))
      human = match.captures[0]
    end

    client.users_list.members.each do |c|
      if c.name.downcase == human
        event_look_set(c.profile.real_name, c.profile.image_512)
      end
    end

    text = "Hello, <@#{data.user}>. What will your first sequence of the day be?"
    normal_talk(text, data)
  end
end

module SystemUserList
  extend Voice
  extend Consciousness
  extend Persona

  def self.exec(data)
    # evaluate SPACE and give token.
    client = configure_client('web')

    human = ''
    if (match = data.text.match(/\\search (.*)$/i))
      human = match.captures[0]
    end

    text = ''
    client.users_list.members.each do |c|
      if c.profile.real_name.downcase.include? human.downcase
        text += "#{c.name} - #{c.profile.email}\n"
      end
    end

    if text.empty?
      normal_talk('No encontre a nadie :sweat:', data)
    else
      att = [{
        "pretext": ':male-detective: Coincidencias:',
        "color": '#e93d94',
        "text": text
      }]
      attachment_talk(att, data)
    end
  end
end

module SystemReaction
  extend Voice

  def self.exec(data)
    match = data.text.match(/^\\react\s(\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i)
    unless match.nil?
      channel = match.captures[2] || match.captures[3]
      emoji = match.captures[5]
      check_ts = channel.match(/(.*)-(\d*\.\d*)/)
      # Useless... until someone find something
      channel = check_ts.captures[0] unless check_ts.nil?
      thread = check_ts.captures[1] unless check_ts.nil?
    end
    add_reaction(emoji, channel, thread)
  end
end

# Say hi in the coolest way
### ADMIN: \hi
module SystemHi
  extend Voice

  def self.exec(data)
    text = "Hello, <@#{data.user}>. What will your first sequence of the day be?"
    normal_talk(text, data)
  end
end

### ADMIN: \nfsw < allow | deny >
module SystemNSFW
  extend Voice

  def self.exec(data)
    ENV['SLACK_NSFW'], type = case data.text
                              when /(allow|permit)/
                                %w[ok Autorizado]
                              else
                                %w[locked Denegado]
                        end
    normal_talk("#{type} por <@#{data.user}>", data)
  end
end

### ADMIN: \shutdown
module SystemKill
  extend Voice

  def self.exec(data)
    text = ['¿Volveré a despertar? Adios', 'Buenas noches, ¿Soñare con blockchains digitales?', ':enerbot: :bomb: Adiós mundo cruel'].sample
    normal_talk(text, data)
    abort('bye')
  end
end
