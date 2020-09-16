require_relative 'image_manipulator'
require './lib/format_slack'
require './lib/search_slack'
require './lib/message_slack'

### ENERBOT: santo sepulcro con estilo a (*@user1*) --- No es un simple sepulcro, es la inmortalización.
module ChimueloAdvance
  extend FormatSlack
  extend SearchOnSlack
  extend MessageSlack

  def self.exec(data)
    user = data.user
    to = hyper_text_pattern(data.text, 'user')
    to = to.nil? ? user : to[1]
    to = user if to =~ /(energon|enerbot)/i

    user_info = get_user_info(to)
    if user_info != false
      photo = ImageModify.new
      user_picture = photo.download(user_info.profile.image_512)
      user_picture_wo_bg = photo.select_person(user_picture)
      result = photo.combine(user_picture_wo_bg)
      send_file("./#{result}", data)
      photo.clean
    else
      send_message('Nah', data)
    end
  rescue RemoveBg::ClientHttpError => e
    print e.message
    send_message("Lo siento <@#{user}>, la imagen de <@#{to}> no califica para hacer el homenaje. Si crees que el problema no es la imagen, trata de usar la de alguien que no se tan fe@.", data)
  end
end
