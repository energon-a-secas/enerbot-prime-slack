require 'nokogiri'
require 'open-uri'
require './lib/message_slack'

### ENERBOT: numeros kino --- Enerbot te dará los números ganadores.
module KinoNumbers
  extend MessageSlack
  def self.exec(data)
    k = (1..25).to_a.shuffle!
    p = (1..100).to_a.shuffle!
    n = k[0..13].sort.join(', ')

    emoji = case p[0]
            when 1..10
              ':thunder_cloud_and_rain:'
            when 11..20
              ':rain_cloud:'
            when 21..30
              ':cloud:'
            when 31..40
              ':partly_sunny:'
            when 41..49
              ':mostly_sunny:'
            when 50
              ':partly_sunny_rain:'
            when 51..70
              ':sunny:'
            when 71..80
              ':full_moon_with_face:'
            when 81..99
              ':rainbow:'
            when 100
              ':newalert:'
    end

    text = ":crystal_ball: Números: #{n}\nProbabilidad de ganar: #{p[0]}% #{emoji} "
    send_message(text, data)
  end
end

### ENERBOT: resultado kino --- Enerbot te dará los números ganadores.
module KinoWinner
  extend MessageSlack

  def self.exec(data)
    doc = Nokogiri::HTML(open('https://losresultados.info/kino/'))
    title = doc.search('img')
    text = ''
    title.each do |v|
      v.attributes.first.each do |vk|
        next if vk == 'src'

        check = vk.value.match(%r{(https://losresultados.*kino-\d{4,5}.jpg)})
        text = check[1] if check
      end
    end

    send_message(text, data)
  end
end
