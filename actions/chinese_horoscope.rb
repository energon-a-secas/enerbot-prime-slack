require 'nokogiri'
require 'open-uri'
require './lib/message_slack'

### ENERBOT: horoscopo chino (rata|buey|tigre|conejo|dragón|serpiente|caballo|cabra|mono|gallo|perro|cerdo) --- ¿Por qué quieren esto?.
module SearchChineseHoroscope
  extend MessageSlack
  def self.exec(data)
    sign = data.text.match(/(rata|buey|tigre|conejo|drag[oó]n|serpiente|caballo|cabra|mono|gallo|perro|cerdo)/i)

    unless sign.nil?
      url_sign = if sign[1] == 'serpiente'
                   'serpientes'
                 else
                   sign[1].gsub('ó', 'o')
      end
      url = "https://www.viaje-a-china.com/zodiacos-chinos/fortuna-mensual/#{url_sign}.htm"
      doc = Nokogiri::HTML(open(url))
      content = ''
      doc.search('div').each do |v|
        content = v.content if v.content.include? 'mes'
      end

      parsed_content = content.gsub('.Horóscopo', ".\nHoróscopo").gsub(')', ")\n")

      month = 'septiembre'

      text = parsed_content.match(/(Horóscopo.*#{month}\)\n.*\n.*#{month}.*?\)\n.*?)\n.*/i)[1]
      style = text.scan(/Hor[oó]scopo.*\)?/)
      style.each do |t|
        text.gsub!(t, "\n*#{t}*")
      end
      send_message(text, data)
    end
  end
end
