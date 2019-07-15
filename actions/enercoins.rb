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

    p user, type, motive
    if type =~ /(\+\+|--)/
      coin, text = update_coins(user, type, motive, data)
      message = "#{text}#{coin}"
    else
      coin = check_account(user)
      message = if data.user == user
                  ":bank: Tu balance de Enercoins es: #{coin}"
                else
                  ":bank: El balance de Enercoins de <@#{user}> es: #{coin}"
                end
    end

    normal_talk(message, data)
  end
end
