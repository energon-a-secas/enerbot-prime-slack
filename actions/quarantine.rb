require './lib/message_slack'
require './lib/format_slack'
require 'open-uri'

### HELP: servicios cuarentena --- ENERBOT te dará servicios para una cuarentena y/o apocalipsis zombie.
module QtService
  extend ImageSlack
  extend FormatSlack
  extend MessageSlack

  def self.exec(data)
    text = "\n"
    web = open('https://raw.githubusercontent.com/devschile/cuarentena/master/README.md', &:read)
    web.each_line do |line|
      check1 = line.match(/^### (.*)$/)
      check2 = line.match(/^\|\[(.*)\]\((.*)\)\|/)
      text += "\n#{check1[1]}\n" unless check1.nil?
      text += "<#{check2[2]}|#{check2[1]}>\n" unless check2.nil?
    end

    text += "\n\n\n Scrappeado sin amor desde <https://devschile.github.io/cuarentena/|DevsChile>"

    message = attachment_style(text, pretext: '*Cuarentena - Servicios de delivery Santiago por categoría*', color: '#e93d94')
    send_attachment(message, data)
  end
end
