require './lib/message_slack'
require './lib/image_slack'
require './lib/format_slack'

### ZENBOT: game --- Zenbot entregará un juego para alinearte los chakras.
module ZenGame
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack

  def self.exec(data)
    game = '<https://thezen.zone|The Zen Zone>'
    game_type = %w[swirl switch break].sample
    game_time = %w[1 3 5].sample
    rules = "*Game:* #{game_type}\n*Time:* #{game_time}m"
    message = attachment_style(rules, pretext: game, author: 'Suggested rules:', color: '#000000')
    send_attachment(message, data)
  end
end

### ZENBOT: link --- Zenbot entregará un link que te hará olvidarte del sprint y la deuda técnica.
module ZenLink
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack

  def self.exec(data)
    link = ['F7PxEy5IyV4', 'c1Ndym-IsQg', '0fcdv0kFVMs', '5kcecd57ht8', 'kI4bDaZ83g4', 'IReEu2kI6oI', '4Bs0qUB3BHQ', 'uUjDxAISCIQ', '6eU6SRsZxGI', 'X6hWc6Ddj1g', 'Md724SxePJM', '6ioSLvAaNF0', 'SEfs5TJZ6Nk', 'xg7f5YO38Hg', 'qAeGN8xUIN0', 'Z9i2QHlKzUI', 'ldFD-L-Csz0', '6Y9nxOGSrmQ', 'Bh66Pr7_6j0', 'wMFbBct-p7c', 'KSBVTabkfBc', 'cEqZthCaMpo', 'ZHI00Gm98KA', '0JFYhqjatBE', '-V3OU_NF4qs', 'vNKCQRZA-Uo', 'dwpus2NIJ-Y', 'XcZOXfOhjeU', 'VPJ7RR06sZ0', '15BGfm9n2Ro', 'n45SBZcQeYQ', 'nGhuxRR7qNM', 'fbPNRVrjMDw', '0jHOX9OCsS8', 'nFAUPT3ZrII', 'xl2DFI6as4I', 'hmb5hf0Gze0', 'w5z5zrsn_DY', 'Ip-K-WUDihE', 'qyqtfAwMRsQ', 'uEgeSp6fmkk', '7Szggbo25VI', 'Y3O7NPPoM_o', 'hTLGrz32Lr4', '6_HcLzr7LTQ', 'cAMiBOvj_nY', 'jgT_6-F44NQ', 'ZM4kLUKhJmM', '3ucdU7URx5g', 'mALKdPnnNp4', 'rlm7WMYWra8', 'ib1IEh5HLNw', 'icS7nj2Glz4', 'f1eTvg5mQ78', 'oXzkri3WlJY', 'KpabiKs7CzM', 'jhjr-b3-WHw', 'T-sUo0_1Z4o', 'Ma57pxALlFA', 'KXNWCEnQBsw', '3W9stxdXdVw', 'N4zH2XbGzqM', 'NaD7EK486x8', 'mgYnki4OPeQ', 'Rfr048CalkE', 'IModb99rRG4', 'uNG8AIX0nsw', 'TzAKr6wHOWk', 'FjfmNvhn1ew', '-iurLhQ_O8I', 'pDNaSCqW8qo', 'vqSdEvolrrI', 'z4dQAnCRK4c', 'vKtBgxzXdO0', 'nYvzRonxCPE', 'nUzMLamWdOU', 'yZq1bdhDTl8', 'kIIRl3_535A', 'fQKXoGmRTJU', 'cODPo5h4e_I', 'f5o9xh1B6Vo', '4nJYJ-QcABs', 'H1zy9KipXwM', 'dO6TpYNZOhc', 'ZUTjxqwFMZw', 'cd5csudD8v8', 'z25AfFJeb6s', 'onXChxcDIpk', 'M0M2O9BXUow', '2v9zjjLmdCk', 'CEvlxND8Efs', 'spK60p2sbrw', 'okZ5mByAK3M', '4JVyw9o5_fg', 'nuBCfVtsRKg', '_0TzBFV8w4g', '3HOaoGE2rJw', 'n2CPLH46kjY', 'UQu_thcN9zs', '3GtpMOxy-cg', 'LkqF2GCQsdM', 'mIGS69keG2M', 'kNv0yIBmTE0', 'VNOEik9L7b8', 'UQn4XkAJWrM', 'cUR3hdJLwpM', 'G3va3Houeo4', 'gS5aKxoBoT0', 'wZxKs52ACHQ', 'TGKVth0ugL8', 'J4bb7M7S1bY', 'QnT4HMoDuto', 'xtSEomVvy0w', 'DK73PlJzCTc', '1dwEip-1VZY', 'QvRML1__0bU', 'yx9mKU3wvgk', 'yTV4Y0hgZlM', 'lRYo12c0eBM', 'Vnv4JQ5GFwA', 'IixtBSGF6r0', 'fKeuGRP7Zj8', 'HPNjkJGv9mU'].sample
    send_message("https://www.youtube.com/watch?v=#{link}", data)
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
