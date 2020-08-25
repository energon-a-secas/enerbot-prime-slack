require './mind/memory'
require './mind/language'
require './voice'

### help: *< user >* *< -- | ++ >* *< motivo >* --- Entrega o remueve enercoins a usuario especificado para hacer ajuste de cuentas.
### help: *< user >* *< balance >*
module Enercoins
  extend Vocal_Mimicry
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    user, type, motive = coin_transaction(data.text)

    case type
    when /(\+\+|--)/
      coin, text, result = update_coins(user, type, motive, data)
      message, icon = if result == true
                        ["#{text}#{coin} :enercoin:", 'approved']
                      else
                        [text, 'x']
                      end
      add_reaction(icon, data.channel, data.ts)
      normal_talk(message, data.channel)
    when /(balance)/
      coin = check_account(user)
      self_balance = ":bank: Tu balance de Enercoins es: #{coin}"
      others_balance = ":bank: El balance de Enercoins de <@#{user}> es: #{coin}"
      if data.user == user
        normal_talk(self_balance, data.user)
      else
        normal_talk(others_balance, data.channel)
      end
      add_reaction('approved', data.channel, data.ts)
    end
  end
end

module Market
  extend Vocal_Mimicry
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    change = data.text.match(/.*\<\@(.*)\>\s(\d{2,3}|.\d{2,3})/)
    user = change.captures[0]
    coins = change.captures[1]
    update_data(user, coins)
  end
end
