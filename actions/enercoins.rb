require './mind/memory'
require './mind/language'
require './voice'

# Get points to brag in front of your friends
module Enercoins
  extend Vocal_Mimicry
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    user, type, motive = coin_transaction(data.text)

    message = case type
              when /(\+\+|--)/
                coin, text, result = update_coins(user, type, motive, data)
                result == true ? "#{text}#{coin}" : text
              when /(balance)/
                coin = check_account(user)
                self_balance = ":bank: Tu balance de Enercoins es: #{coin}"
                others_balance = ":bank: El balance de Enercoins de <@#{user}> es: #{coin}"
                data.user == user ? self_balance : others_balance
    end

    normal_talk(message, data)
  end
end
