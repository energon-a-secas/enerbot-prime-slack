# frozen_string_literal: true

require './mind/memory'
require './voice'

def get_values(text)
  value = text.match(/^<@(.*?)>\s(\+\+|--|check)\s(.*)/i)
  [value.captures[0], value.captures[1], value.captures[2]]
end

# Get points to brag in front of your friends
module Enercoins
  extend FireOps
  extend Voice

  def self.exec(data)
    user, type, motive = get_values(data.text)

    total = if type =~ /(\+\+|--)/
              update_coins(user, type, motive, data)
            else
              check_coins(user)
            end
    normal_talk("<@#{user}> has #{total} enercoins", data)
  end
end
