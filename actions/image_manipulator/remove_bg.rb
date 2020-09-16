require 'remove_bg'
require './lib/format_slack'
require './lib/search_slack'
require './lib/message_slack'

### ENERBOT: (remueve|elimina) fondo de (*@user1*) --- No es un simple sepulcro, es la inmortalización.
module ImageRemoveBG
  extend MessageSlack
  extend SearchOnSlack
  extend FormatSlack

  def self.exec(data)
    user = data.user
    to = hyper_text_pattern(data.text, 'user')
    to = to.nil? ? user : to[1]
    to = user if to =~ /(energon|enerbot)/i

    user_info = get_user_info(to)
    if user_info != false
      url = user_info.profile.image_512
      old_file = './actions/image/rm_bg_slack.png'
      new_file = './actions/image/edited_bg_slack.png'
      open(url) do |f|
        File.open(old_file, 'wb') do |file|
          file.puts f.read
        end
      end
      RemoveBg.from_file(old_file, api_key: ENV['REMOVE_BG_KEY'], overwrite: true).save(new_file)
      send_file(new_file, data)
      File.delete(old_file)
      File.delete(new_file)
    else
      send_message('Nah', data)
    end
  rescue RemoveBg::ClientHttpError => e
    print e.message
    send_message("Lo siento <@#{user}>, la imagen de <@#{to}> no califica para hacer el homenaje. Si crees que el problema no es la imagen, trata de usar la de alguien que no se tan fe@.", data)
  end
end
