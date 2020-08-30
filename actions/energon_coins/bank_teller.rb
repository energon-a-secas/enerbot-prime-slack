require_relative 'blockchain'
require './lib/message_slack'
require './lib/format_slack'

### ENERBOT: (*@user1*) (--|++) (*motive*) --- Entrega o remueve enercoins a usuario especificado para hacer ajuste de cuentas.
### ENERBOT: (*@user1*) (*balance*)
module BankTeller
  extend Blockchain
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    user, type, motive = coin_pattern(data.text)

    case type
    when /(\+\+|--)/
      coin, text, result = update_coins(user, type, motive, data)
      message, icon = if result == true
                        ["#{text}#{coin} :enercoin:", 'approved']
                      else
                        [text, 'x']
                      end
      add_reaction(icon, data.channel, data.ts)
      send_message(message, data.channel)
    when /(balance)/
      coin = check_account(user)
      self_balance = ":bank: Tu balance de Enercoins es: #{coin}"
      others_balance = ":bank: El balance de Enercoins de <@#{user}> es: #{coin}"
      if data.user == user
        send_message(self_balance, data.user)
      else
        send_message(others_balance, data.channel)
      end
      add_reaction('approved', data.channel, data.ts)
    end
  end
end
