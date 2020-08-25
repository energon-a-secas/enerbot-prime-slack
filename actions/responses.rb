require './voice'
require './mind/language'
require './mind/consciousness'

# When there's nothing to say, say something
### help: recomienda *< texto_relevante >* --- Ivan quería esto.
### help: dame amor || i love you --- Entregar amor es uno de los principales objetivos del área "Continuous Love Delivery (CLD)" de ENERGON.
module ResponseHi
  extend Voice
  def self.exec(data)
    text = case data.text
           when /(holi|hola)/
             ['Holiwis', "Oh, Hi <@#{data.user}>!", 'Hi desu!'].sample
           when /(i love u|i love you|dame amor)/
             "I love you #{rand 10_000}"
           when /(recomienda)/
             question = data.text.match(/enerbot\srecomienda\s(.*)/)
             q = question.captures[0].gsub(' ', '+')
             "lmgtfy.com/?q=#{q}"
           else
             ':ocean:'
           end

    normal_talk(text, data)
  end
end

module ResponseAgent
  extend Voice
  def self.exec(data)
    normal_talk(['La Karen sabe responder a eso', 'Arresteme pronto', 'https://youtu.be/ibsJaAUUtPA'].sample, data)
  end
end

### help: inducción --- Enerbot te revelará los misterios del universo y de paso la inducción.
module ResponseIntro
  extend Voice
  extend Conversation
  extend Consciousness

  def self.exec(data)
    # add_reaction('robot_face', data, data.ts)
    hello = ['Yo sólo puedo mostrarte la puerta, tú eres quien la tiene que atravesar.', 'Si tomas la pastilla azul la historia acaba, depiertas en tu cama y crees lo que tú quieras creer. Si tomas la roja te quedas en el País de las Maravillas y te enseño qué tan profundo es el hoyo. Recuerda, solo te estoy ofreciendo la verdad, nada más'].sample

    channel = data.user
    if (match = data.text.match(/<@(.*?)>$/i))
      channel = match.captures[0]
    end
    dm = direct_talk(channel)
    normal_talk(hello, dm)
    sleep(1)
    normal_talk('¿Quieres saber la verdad?', dm)
    text, valid = dialog(data.user, '(no|yes|nes|weno|si|dale|ya|bueno)', 5, dm, 'chat')
    if valid == true
      case text
      when /(yes|si|dale|nes|weno|ya|bueno)/
        normal_talk('¿Te sientes preparado?', dm)
        text, valid = dialog(data.user, '(no|yes|nes|weno|si|dale|ya|bueno)', 5, dm, 'chat')
        case text
        when /(yes|weno|si|dale|ya|bueno)/
          normal_talk('Aún no lo estás. Te hablaré cuando estime conveniente', dm)
        when /(no|nes|para nada|tal vez)/
          ans = ''
          client = configure_client('web')
          client.conversations_list.channels.each do |c|
            icon = ':star:'
            description = c.purpose.value.empty? ? 'To do' : c.purpose.value
            ans += "#{icon} <##{c.id}|#{c.name}> --- #{description}\n"
          end
          normal_talk("Bueno, aquí tienes el listado de canales, arreglatelas como puedas:\n#{ans}", dm)
        end
      else
        normal_talk('Tú te lo pierdes', dm)
      end
    else
      normal_talk('Desearía seguir prestandote atención, pero tengo mejores cosas que hacer.', dm)
    end
  end
end

### help: presentate con estilo --- Entrega presentación utilizada en conferencias internacionales.
module ResponsePresentation
  extend Voice

  def self.exec(data)
    text = ['https://i.imgur.com/MJvyZQT.gif'].sample
    normal_talk(text, data)
  end
end

### help: give me a cybersecurity excuse --- Genera un reporte de seguridad.
module ResponseSecurity
  extend Voice

  def self.exec(data)
    threat_actors = ['Russians',
                     'NSA',
                     'FBI',
                     'North Koreans',
                     'Chinese',
                     'Anonymous collective',
                     'teenage hacking prodigies',
                     'Iranians',
                     'KGB',
                     'industrial spies',
                     'competition',
                     'Europeans',
                     'Americans',
                     'cyber terrorists',
                     'advanced persistent threats',
                     'state actors',
                     'rogue AIs',
                     'APTs',
                     'Fancy Bears',
                     'foreign assets',
                     'master hackers',
                     'technology whiz kids',
                     'script kiddies',
                     'hacking activists',
                     'hacking people',
                     'security community',
                     'internet crowd']
    methods = ['0-day exploits',
               'unprecedented XSS vulnerabilities',
               'infiltrators',
               'overwhelming force',
               'botnets',
               'ransomware',
               'DDoS attacks',
               'IoT malware',
               'advanced techniques',
               'hacking drones',
               'cyborg bees',
               'digital nukes',
               'the open door in our basement',
               'that one vulnerability we were going to patch next Tuesday',
               'that other vulnerability we were going to patch next tuesday',
               'something something vulnerability',
               "vectors we really couldn't have prevented",
               'vulnerabilities in a 3rd party solution',
               'weaknesses in our vendors',
               'nefarious techniques',
               'an issue in Wordpress 1.0',
               'Heartbleed',
               'a vulnerability in Windows XP SP1',
               'pen and paper based social engineering',
               'an open window in the server room',
               '30 - 50 feral hogs']
    targets = ['gain access to some data',
               'cause a minor disturbance',
               'potentially access some customer data',
               'cause an undetermined amount of damage',
               'partially disrupt our services',
               'breach our high security servers',
               'glimpse into our database',
               'transfer 7 petabytes of data',
               'extract some private keys',
               "do something, but we aren't quite sure what it is",
               'make a mess', 'make us look bad',
               'force us to release this report',
               'hack the coffee maker',
               'install a C99']
    mitigations = ['made everyone promise to be super super careful',
                   'gotten ISO certified',
                   'gotten PCI certified',
                   'worked with industry leading specialists',
                   'upskilled our cafeteria staff',
                   'hired external consultants',
                   'worked with law enforcement',
                   'bought an IDS',
                   'twiddled with our firewall',
                   'been pretty good about security',
                   "hired some people with 'CISSP' after their names",
                   'watched a YouTube video on cyber security',
                   'told them to not do it again',
                   'said that we are very sorry',
                   'copy-pasted a security policy we found on Google',
                   'hired a Russian dude',
                   'watched the movie Hackers 8 times back to back',
                   'sent one of our guys to Defcon',
                   'put a rotating lock GIF on our website']

    text = "Why the f*ck were you breached?:\n>>>The f*cking #{threat_actors.sample} used #{methods.sample} to #{targets.sample}. But we have since #{mitigations.sample}, so it will never happen again."
    normal_talk(text, data)
  end
end
