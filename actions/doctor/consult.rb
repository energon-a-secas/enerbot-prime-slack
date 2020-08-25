require './voice'
require './mind/consciousness'
require 'open-uri'

### DOCTOR: dame tips || dame consejos --- ENER-DOC te explicará que hacer para mantenerte sano y a salvo.
module DoctorTips
  extend Voice
  extend Persona

  def self.exec(data)
    add_reaction('helicopter', data.channel, data.ts)
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    actions = ['Lávate las manos durante al menos 20 segundos con agua y jabón.', 'Evita tocarte la cara.', 'Mantén una distancia de 1 a 2 metros de otras personas en la medida de lo posible.'].sample
    supplements = ['Agua de manzanilla nunca falla.', 'La vitamina C no te hará inmune pero te ayudará con los resfríos comunes.', 'Harto liquido, ahí lo dejo.'].sample
    office = ['Evita las reuniones en salas no diseñadas para sostener un ambiente agradable para más de 3 personas.', 'No compartas tu mate', 'Eviten utilizar los mismos utencilios de la cocina.', 'Trabaja remoto si puedes.', 'No vengas si ya estas resfriado. Agradecemos tu compromiso, pero no apreciamos tus mocos.'].sample
    protips = ['La mascarilla no te da inmunidad, solo ayuda a que tú no contagies a otros.', 'Evita el metro en horario punta.'].sample

    text = ":potable_water: *Acciones:* #{actions}\n:pill: *Suplementos:* #{supplements}\n:office: *Oficina:* #{office}\n:star: *Pro TIPs:* #{protips}"
    normal_talk(text, data)
    event_look_revert
  end
end

### HELP: servicios cuarentena --- ENERBOT te dará servicios para una cuarentena y/o apocalipsis zombie.
module DoctorServices
  extend Voice

  def self.exec(data)
    text = "\n"
    web = open('https://raw.githubusercontent.com/devschile/cuarentena/master/README.md', &:read)
    web.each_line do |line|
      check1 = line.match(/^### (.*)$/)
      check2 = line.match(/^\|\[(.*)\]\((.*)\)\|/)
      if check1 != nil
        text += "\n#{check1[1]}\n"
      end
      if check2 != nil
        text +=  "<#{check2[2]}|#{check2[1]}>\n"
      end
    end

    text += "\n\n\n Scrappeado sin amor desde <https://devschile.github.io/cuarentena/|DevsChile>"

    att = [{
      "pretext": '*Cuarentena - Servicios de delivery Santiago por categoría*',
      "color": '#e93d94',
      "text": text.split("\n")[0..-1].join("\n")
    }]
    attachment_talk(att, data)
  end
end

### DOCTOR: atiendeme --- ENER-DOC te atenderá por interno.
module DoctorAsk
  extend Voice
  extend Conversation
  extend Persona

  def self.exec(data)
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    add_reaction('medical_symbol', data.channel, data.ts)
    hello = ['Cuéntame, ¿qué te sucede?.', 'Espero que estes usando una VPN para hablarme, ¿cómo te has sentido ultimamente?'].sample

    channel = direct_talk(data.user)
    normal_talk(hello, channel)
    sleep(1)
    text, valid = dialog(data.user, '(resfriad|enferm|preocupad|asustad|dolor|duele)', 5, channel, 'chat')
    if valid == true
      normal_talk('Te diagnostico con seguir viviendo', channel)
    else
      normal_talk('Desearía seguir prestandote atención, pero tengo mejores cosas que hacer.', channel)
    end
    event_look_revert
  end
end

### DOCTOR: casos de corona confirmados --- ENER-DOC te dará la cifra actual.
module DoctorAsk
  extend Voice
  extend Conversation
  extend Persona

  def self.exec(data)
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    add_reaction('medical_symbol', data.channel, data.ts)
    hello = ['Cuéntame, ¿qué te sucede?.', 'Espero que estes usando una VPN para hablarme, ¿cómo te has sentido ultimamente?'].sample

    channel = direct_talk(data.user)
    normal_talk(hello, channel)
    sleep(1)
    text, valid = dialog(data.user, '(resfriad|enferm|preocupad|asustad|dolor|duele)', 5, channel, 'chat')
    if valid == true
      normal_talk('Te diagnostico con seguir viviendo', channel)
    else
      normal_talk('Desearía seguir prestandote atención, pero tengo mejores cosas que hacer.', channel)
    end
    event_look_revert
  end
end
