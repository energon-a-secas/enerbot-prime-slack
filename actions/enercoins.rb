require './mind/memory'
require './voice'

def get_values(text)
    user, type, motive = text.match(/^<@(.*?)>.*(\+\+|--|balance)(.*)/ix).try(:captures)
    [user, type, motive]
end

# Get points to brag in front of your friends
module Enercoins
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    user, type, motive = get_values(data.text)

    if type =~ /(\+\+|--)/
      coin, text = update_coins(user, type, motive, data)
      message = "#{text}#{coin}"
    else
      coin = check_account(user)
      if data.user == user
        message = ":bank: Tu balance de Enercoins es: #{coin}"
      else
        message = ":bank: El balance de Enercoins de <@#{user}> es: #{coin}"
      end
    end

    normal_talk(message, data)
  end
end
