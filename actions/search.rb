require './voice'

# Module dedicated to Security
module Search_horoscope
  extend Voice
  def self.exec(data)
    require 'json'
    require 'net/http'

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
