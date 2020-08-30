require './lib/message_slack'
require './lib/image_slack'
require './lib/format_slack'

### ZENBOT: game --- Zenbot entregará un juego para alinearte los chakras.
module ZenGame
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack

  def self.exec(data)
    event_look_set('Zenbot', 'https://i.imgur.com/Fswhv2H.png')
    game = '<https://thezen.zone|The Zen Zone>'
    game_type = %w[swirl switch break].sample
    game_time = %w[1 3 5].sample
    rules = "*Game:* #{game_type}\n*Time:* #{game_time}m"
    message = attachment_style(rules, pretext: game, author: 'Suggested rules:', color: '#000000')
    send_attachment(message, data)
    event_look_revert
  end
end

# game = %w(swirl switch break).sample
# time = %w(1 3 5).sample
# check_game = text.match(/(swirl|switch|break)/)
# check_time = text.match(/([135])/)
#
# game = check_game[1] unless check_game.nil?
# time = check_time[1] unless check_time.nil?
#
# url = "https://thezen.zone/#{game}/#{time}"
# message = "<#{url}|#{game}>"
