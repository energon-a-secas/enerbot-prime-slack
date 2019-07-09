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

  def secure_coins(user_to, data)
    firebase = client
    last_call = firebase.get("enercoin/#{user_to}/user").body
    last_call_ts = firebase.get("enercoin/#{user_to}/ts").body
    calling_user = data.user

    p "Ultima llamada por #{last_call} con un TS de #{last_call_ts}"
    p "Llamada actual por #{calling_user} con un TS de #{data.ts}"

    case
    when user_to == calling_user
      false
    when calling_user == last_call
      minutes = data.ts.to_i - last_call_ts.to_i
      true if minutes >= 400
    else
      true
    end

  end

  def update_coins(user, type, data)
    coins = check_coins(user)
    new_coins = resolve(coins, type)


    firebase = client
    firebase.update('enercoin',
                    "#{user}/coin" => new_coins,
                    "#{user}/user" => data.user,
                    "#{user}/ts" => data.ts) if secure_coins(user, data)
    check_coins(user)
  end
end
