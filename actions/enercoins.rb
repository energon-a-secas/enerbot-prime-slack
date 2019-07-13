# frozen_string_literal: true

require './mind/memory'
require './voice'
def get_values(text)
  begin
    value = text.match(/^<@(.*?)>\s(\+\+|--|check)\s(.*)/i)

    user = value.captures[0]
    type = value.captures[1]
    motive = value.captures[2]

    [user, type, motive]
  rescue NoMethodError

  end

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

    end

    normal_talk(message, data)
  end
end
