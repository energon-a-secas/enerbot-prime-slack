require 'open-uri'

### ENERBOT: paya random --- Enerbot te entregará una paya aleatoria.
module PayaRandom
  extend MessageSlack

  def self.exec(data)
    body = URI.open("https://payagenerator3000.herokuapp.com/").read
    text = body.gsub('<h1> Paya Generator 3000 </h1>', "\n:flag-cl::flag-cl::flag-cl:\n").gsub('<br>', "\n")
    send_message(text, data)
  rescue OpenURI::HTTPError => e
    puts e.message
    retry
  end
end