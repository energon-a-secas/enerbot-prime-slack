# frozen_string_literal: true

require './mind/memory'
require './voice'

def get_values(text)
  value = text.match(/^<@(.*?)>\s(\+\+|--|check)$/i)
  [value.captures[0], value.captures[1]]
end

# Get points to brag in front of your friends
module Enercoins
  extend FireOps
  extend Voice

  def self.exec(data)
    user, type = get_values(data.text)
    if type =~ /(\+\+|--)/
      update(user, type, data)
    else
      check(user, data)
    end
  end

  def self.check(user, data)
    quantity = check_coins(user)
    normal_talk("<@#{user}> has #{quantity} enercoins", data)
  end

  def self.update(user, type, data)
    total_coins = update_coins(user, type)
    normal_talk("<@#{user}> has #{total_coins} enercoins", data)
  end
end
