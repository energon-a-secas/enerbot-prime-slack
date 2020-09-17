require 'json'
require './lib/message_slack'
require './lib/image_slack'

### ENERBOT: horoscopo (*sign*) --- Enerbot utilizará sus contactos en la televisión para traerte las mejores predicciones del día.
module SearchHoroscope
  extend MessageSlack
  extend ImageSlack

  def self.exec(data)
    cover = ['Pedro Engel', 'Tía Yoli', 'Tía Yoli'].sample
    image = case cover
            when /Pedro Engel/
              'https://i.imgur.com/om1Rkij.png'
            when /Tía Yoli/
              'https://i.imgur.com/Clre94F.png'
            end

    event_look_set(cover, image)
    option = data.text.match(/(aries|tauro|g[eé]minis|c[áa]ancer|leo|virgo|libra|escorpi[oó]n|sagitario|capricornio|acuario|piscis)/i)[0].downcase.gsub('ó', 'o').gsub('á', 'a').gsub('é', 'e')
    sign = %w[aries tauro geminis cancer leo virgo libra escorpion sagitario capricornio acuario piscis]
    text = if sign.include? option
             api = JSON.parse(Net::HTTP.get(URI('https://api.xor.cl/tyaas/')))
             p api
             signo = api['horoscopo'][option]
             "Horóscopo para *#{option}* hoy: #{Date.today}\n:heart:*Amor:* #{signo['amor']}\n:medical_symbol:*Salud:* #{signo['salud']}\n:moneybag:*Dinero:* #{signo['dinero']}\n:art:*Color:* #{signo['color']}\n:8ball:*Número:* #{signo['numero']}"
           elsif option == 'ofiuco'
             ':enerfiuco:'
           else
             ["Intenta con mas ganas y verifica que #{option} sea un signo.", "¿Pedro Engel sabe del signo #{option}?", 'Es culpa de QA', 'Escriba mas fuerte que tengo una toalla'].sample
           end
    send_message(text, data)
    event_look_revert
    # Net::OpenTimeout
  end
end

### ENERBOT: compatibilidad (*sign*) --- Enerbot romperá tus expectativas amorosas.
module SearchCompability
  extend MessageSlack

  def self.exec(data)
    api = JSON.parse(Net::HTTP.get(URI('https://zodiacal.herokuapp.com/api')))
    check = data.text.match(/(aries|tauro|geminis|cancer|leo|virgo|libra|escorpion|sagitario|capricornio|acuario|piscis)/i)
    unless check.nil?
      sign = check[1].downcase.gsub('ó', 'o').gsub('á', 'a')
      sign_list = {
        'aries' => ['Aries', 0],
        'tauro' => ['Taurus', 1],
        'geminis' => ['Gemini', 2],
        'cancer' => ['Cancer', 3],
        'leo' => ['Leo', 4],
        'virgo' => ['Virgo', 5],
        'libra' => ['Libra', 6],
        'escorpion' => ['Scorpio', 7],
        'sagitario' => ['Sagittarius', 8],
        'capricornio' => ['Capricorn', 9],
        'acuario' => ['Aquarius', 10],
        'piscis' => ['Pisces', 11]
      }
      element = sign_list[sign]
      zodiacal = element[0].downcase
      z = api[element[1]]
      response = z['compatibility'].join(',').gsub(' ', '').gsub(',', ', ')
      sign_list.each do |k, e|
        response.gsub!(e[0], k.capitalize)
      end
      text = ":tinder: Signos compatibles con *#{zodiacal.capitalize}*: #{response}."
      send_message(text, data)
    end
  end
end

### ENERBOT: que caballero dorado soy (*sign*) --- Enerbot hará despertar tu cosmos interior.
module SearchKnight
  extend MessageSlack

  def self.exec(data)
    random_quote = ['El viejo maestro me dijo que....', '¿Alguna vez has sentido tu cosmo recorriendo hasta la última célula de tu cuerpo?', 'Aquel que no escribe su signo, es Piscis :rose:', '¡Imposible se mueve a la velocidad de la luz no pude ver su ataque!'].sample
    check = data.text.match(/(aries|tauro|geminis|cancer|leo|virgo|libra|escorpion|sagitario|capricornio|acuario|piscis)/i)
    text = if check.nil?
             random_saint = [['Jabu de Unicorn', 'https://i.imgur.com/ERiK2ht.png'], ['Ichi de Hydra', 'https://i.imgur.com/ucZ6Vpr.png']].sample
             send_message(random_quote, data.channel, data.ts)
             "Eres: #{random_saint[0]}\n#{random_saint[1]}"
           else
             sign = check[1].downcase.gsub('ó', 'o').gsub('á', 'a')
             sign_list = {
               'aries' => ['Aries', 'Mū de Aries', 'https://i.imgur.com/JtblYWd.jpg'],
               'tauro' => ['Taurus', 'Aldebaran de Taurus', 'https://i.imgur.com/wsJNMyF.jpg'],
               'geminis' => ['Gemini', ['Saga de Geminis', 'Kanon de Geminis'].sample, ['https://i.imgur.com/b5dLSWL.jpg', 'https://i.imgur.com/dUtKvEx.jpg'].sample],
               'cancer' => ['Cancer', 'Deathmask de Cancer', 'https://i.imgur.com/Atzs8it.png'],
               'leo' => ['Leo', 'Aiolia de Leo', 'https://i.imgur.com/EUJiMBH.jpg'],
               'virgo' => ['Virgo', 'Shaka de Virgo', 'https://i.imgur.com/wr1dNVF.jpg'],
               'libra' => ['Libra', 'Dohko de Libra', 'https://i.imgur.com/1BjXUdf.jpg'],
               'escorpion' => ['Scorpio', 'Milo de Scorpio', 'https://i.imgur.com/pTmoZYI.jpg'],
               'sagitario' => ['Sagittarius', 'Aiolos de Sagittarius', 'https://i.imgur.com/tPM8Euq.jpg'],
               'capricornio' => ['Capricorn', 'Shura de Capricorn', 'https://i.imgur.com/vn2AlP9.png'],
               'acuario' => ['Aquarius', 'Camus de Aquarius', 'https://i.imgur.com/081KOMN.png'],
               'piscis' => ['Pisces', 'Aphrodite de Piscis', 'https://i.imgur.com/ph94wC6.png'],
               'ofiuco' => ['Ofiuco', 'Gran Patriarca', 'https://i.imgur.com/6rOqsaN.jpg']
             }
             element = sign_list[sign]
             zodiacal_name = element[1]
             zodiacal_image = element[2]
             "Según tu signo:\n*Caballero:* #{zodiacal_name}\n#{zodiacal_image}"
           end
    send_message(text, data)
  end
end
