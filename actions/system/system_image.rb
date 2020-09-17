require './lib/message_slack'
require './lib/client_slack'
require './lib/image_slack'

# I love Shin Getter Robot
### HELP: mode (*@username*) || (slackbot|handsome|quarantine|che|marcha|pci|huemul)
module SystemImage
  extend MessageSlack
  extend ClientSlack
  extend ImageSlack

  def self.exec(data)
    costume = {
      /poli/ => ['ENER-POLI', 'https://i.imgur.com/gKMpwYS.png'],
      /slackbot/ => ['Slackbot', 'https://i.imgur.com/38PureM.jpg'],
      /handsome/ => ['Handsome Enerbot', 'https://i.imgur.com/VXUaZBW.png'],
      /quarantine/ => ['ENER-SEALED', 'https://i.imgur.com/tWBNy41.png'],
      /prime/ => ['Prime', 'https://i.imgur.com/ZD0FCTl.png'],
      /(che|argentino)/ => [['Che Enerbot', 'Enerbot Gaucho'].sample, ['https://i.imgur.com/eBlJolG.png', 'https://i.imgur.com/SdQnJha.png'].sample],
      /(corona|coronavirus)/ => ['Enerbot S.', 'https://i.imgur.com/80BYGyJ.png'],
      /order 66/ => ['Emperor Enerbot', 'https://i.imgur.com/By8dfzf.png'],
      /pinocho/ => ['Pinocho', 'https://i.imgur.com/ybzUsex.png'],
      /magnus/ => ['EnerMagnus', 'https://i.imgur.com/Dw7t6Ae.png'],
      /infinite/ => ['Enherbot', 'https://i.imgur.com/HT4r0YP.png'],
      /huemul/ => ['Not Huemul', 'https://avatars2.githubusercontent.com/u/17724906?s=200&v=4'],
      /(wall|trump)/ => ['Enerwall', 'https://i.imgur.com/IHDlzKS.png'],
      /marcha/ => ['Super Cabo Enerbot', 'https://i.imgur.com/12CNUpm.png'],
      /pci/ => ['Inoffensive cron', 'https://i.imgur.com/vtzYstx.png'],
      /bonvaold/ => ['Bonvallet', 'https://i.imgur.com/LcahJ7p.png'],
      /capitan/ => ['Capitán Enerbot', 'https://i.imgur.com/9pwhnZh.png']

    }

    bot_look = ['Enerbot', 'https://i.imgur.com/80BYGyJ.png'] # ['enerbot', 'https://i.imgur.com/1n1Uohi.png']
    costume.keys.find { |key| bot_look = costume[key] if key =~ data.text }
    event_look_set(bot_look[0], bot_look[1])

    if (match = data.text.match(/<@(.*?)>$/i))
      user = match.captures[0]
      imitate_look(user)
    end

    text = ['I am thou, thou art I', '¡No hay hilos en mí!', "Sin hilos yo me sé mover, yo puedo andar y hasta correr\nlos tenía y los perdí, soy libre soy feliz."].sample
    send_message(text, data)
  end
end

module SystemImageBeyond
  extend MessageSlack
  extend ClientSlack
  extend ImageSlack

  def self.exec(data)
    human = ''
    if (match = data.text.match(/\\revive (.*)$/i))
      human = match.captures[0]
    end
    full_list = get_user_list
    full_list.members.each do |c|
      event_look_set(c.profile.real_name, c.profile.image_512) if c.name.downcase == human
    end

    text = "Hello, <@#{data.user}>. What will your first sequence of the day be?"
    send_message(text, data)
  end
end

module SystemCustomImage
  extend MessageSlack
  extend ClientSlack
  extend ImageSlack

  def self.exec(data)
    text = data.text.match(/\s(.*)<(.*)>/)
    if text.nil?
      image = 'Meh'
      name = ''
    else
      name = text[1]
      image = text[2]
    end
    event_look_set(name, image)
    send_message('Hola', data)
  end
end
