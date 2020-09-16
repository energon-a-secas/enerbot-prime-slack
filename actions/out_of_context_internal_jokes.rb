require './lib/message_slack'

module UselessData
  extend MessageSlack

  def self.french(data)
    text = "Dato inútil: En la versión francesa de los cartoons donde actúa Pepe le Pew, este tiene un acento italiano cuando habla.\nPor eso no entendía cuando me hablaban de él al principio ya que en español y en inglés, habla un seudo francés, y yo no veía esos cartoons en esos idiomas."
    send_message(text, data)
  end
end

###
module OCIJokes
  extend MessageSlack
  def self.exec(data)
    case data.text
    when /dato in[úu]til/
      UselessData.french(data)
    else
      ['g-t-scl-energon'].each { |v| send_message("No supe responderle a #{data.user} esto: #{data.text}", v) } if data =~ /enerbot/i
    end
  end
end
