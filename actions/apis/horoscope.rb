require 'json'
require './lib/message_slack'

### help: horoscopo (*sign*) --- Enerbot utilizará sus contactos en la televisión para traerte las mejores predicciones del día.
module SearchHoroscope
  extend MessageSlack

  def self.exec(data)
    option = data.text.split[2].downcase.gsub('ó', 'o').gsub('á', 'a')
    sign = %w[aries tauro geminis cancer leo virgo libra escorpion sagitario capricornio acuario piscis]
    text = if sign.include? option
             api = JSON.parse(Net::HTTP.get(URI('https://api.adderou.cl/tyaas/')))
             signo = api['horoscopo'][option]
             "Horóscopo para *#{option}* hoy: #{Date.today}\n:heart:*Amor:* #{signo['amor']}\n:medical_symbol:*Salud:* #{signo['salud']}\n:moneybag:*Dinero:* #{signo['dinero']}\n:art:*Color:* #{signo['color']}\n:8ball:*Número:* #{signo['numero']}"
           elsif option == 'ofiuco'
             ':enerfiuco:'
           else
             ["Intenta con mas ganas y verifica que #{option} sea un signo.", "¿Pedro Engel sabe del signo #{option}?", 'Es culpa de QA', 'Escriba mas fuerte que tengo una toalla'].sample
           end
    send_message(text, data)
  end
end

### help: compatibilidad (*sign*) --- Enerbot te golpeará con la realidad sobre tu crush.
module SearchCompability
  extend MessageSlack

  def self.exec(data)
    api = JSON.parse(Net::HTTP.get(URI('https://zodiacal.herokuapp.com/api')))
    text = 'aries famous_people'
    check = text.match(/(Aries|Taurus|Gemini|Cancer|Leo|Virgo|Libra|Scorpio|Sagittarius|Capricorn|Aquarius|Pisces)/i)
    unless check.nil?
      zodiacal = check[1]
      api.each do |v|
        if v['name'].downcase == zodiacal
          list = v['compatibility'].join(',').gsub(' ', '').gsub(',', ', ')
          text = ":tinder: Signos compatibles con *#{v['name']}*: #{list}"
        end
      end
      send_message(text, data)
    end
  end
end
