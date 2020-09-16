require 'date'
require 'json'
require 'net/http'
require './lib/message_slack'
require './lib/format_slack'
require './lib/image_slack'

### ENERBOT: sismo (1|2|3) --- Enerbot decidirá si es momento de entregarse al pánico. Default 1.
module ChileEarthQuakes
  extend MessageSlack
  extend FormatSlack
  extend ImageSlack

  def self.exec(data)
    uri = 'https://api.gael.cl/general/public/sismos'

    results = case data.text
              when /1/; then 1
              when /2/; then 2
              when /3/; then 3
              when /ultimos/; then 4
              else
                1
              end
    text = ''
    event_text = results == 1 ? 'Último evento' : 'Últimos eventos'
    pretext = ":flag-cl: #{event_text}:"
    parsed_page = JSON.parse(Net::HTTP.get(URI(uri)))
    results.times.each do |v|
      last = parsed_page[v]
      text += "\n:clock1: *#{last['Fecha'].gsub(' ', '*: ')}\n        *Ubicación:* #{last['RefGeografica']}\n        *Magnitud:* #{last['Magnitud']}\n"
    end
    attach = attachment_style(text, color: 'ff0000', pretext: pretext)
    event_look_set(['Marcelo Lagos'].sample, ['https://i.imgur.com/D0BfJMo.png', 'https://i.imgur.com/0oNvHu1.png'].sample)

    send_attachment(attach, data)
    event_look_revert
  end
end
