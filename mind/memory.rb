# frozen_string_literal: true

# Firebase methods
require 'firebase'

module FireOps
  def client(base_uri = ENV['FIREBASE_ENDPOINT'], json = './config/firebase.json')
    key = File.open(json).read
    Firebase::Client.new(base_uri, key)
  end

  def resolve(val, action)
    case action
    when '++' then val + 1
    when '--' then val - 1
    else
      val
    end
  end

  def self.create_user(user)
    firebase = client
    firebase.update('enercoin',
                    "#{user}/coin" => 0)
  end

  def check_coins(user)
    firebase = client
    coin = firebase.get("enercoin/#{user}/coin")
    create_user(user) if coin.body.nil?
    coin.body
  end

  def update_coins(user, type)
    coins = check_coins(user)
    firebase = client
    firebase.update('enercoin',
                    "#{user}/coin" => resolve(coins, type),
                    "#{user}/ts" => Time.now.strftime('%H:%M:%S').to_s)
    check_coins(user)
  end
end
