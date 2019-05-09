require './voice'
require 'json'
require 'net/http'

# Module dedicated to Security
module SearchHoroscope
  extend Voice

  def self.exec(data)
    option = data.text.split[2]
    sign = %w[aries
              tauro
              geminis
              cancer
              leo
              virgo
              libra
              escorpion
              sagitario
              capricornio
              acuario
              piscis]
    text = if sign.include? option
             api = JSON.parse(Net::HTTP.get(URI('https://api.adderou.cl/tyaas/')))
             signo = api['horoscopo'][option]
             <<-HEREDOC
      Horóscopo para *#{option}* hoy: #{Date.today}
     :heart:*Amor:* #{signo['amor']}
     :medical_symbol:*Salud:* #{signo['salud']}
     :moneybag:*Dinero:* #{signo['dinero']}
     :art:*Color:* #{signo['color']}
     :8ball:*Número:* #{signo['numero']}
             HEREDOC
           elsif option == 'ofiuco'
             ':enerfiuco:'
           else
             "[WARN] Intentalo pero con mas ganas y verifica que #{option} sea un signo."
           end
    normal_talk(text, data)
  end
end

# Earthquakes
module SearchEarthquakes
  extend Voice

  def self.exec(data)
    api = JSON.parse(Net::HTTP.get(URI('https://chilealerta.com/api/query/?user=demo&select=ultimos_sismos&country=chile')))
    chile = api['ultimos_sismos_chile'][0]
    text = <<-HEREDOC
    :clock1: *Hora:* #{chile['chilean_time']}
    :earth_americas: *Ubicación:* #{chile['reference']}
    :triggered_energon: *Magnitud:* #{chile['magnitude']}
    HEREDOC
    normal_talk(text, data)
  end
end
