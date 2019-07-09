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

  def fire_get(user, path)
    firebase = client
    firebase.get("enercoin/#{user}/#{path}").body
  end

  def create_user(user)
    firebase = client
    firebase.update('enercoin',
                    "#{user}/coin" => 0)
  end

  def check_coins(user)
    coins = fire_get(user, 'coin')
    create_user(user) if coins.nil?
    fire_get(user, 'coin')
  end

  def secure_coins(user, data)
    last_call = fire_get(user, 'user')
    last_call_ts = fire_get(user, 'ts').to_i
    current_call = data.user
    current_call_ts = data.ts.to_i

    p "Ultima llamada por #{last_call} con un TS de #{last_call_ts}"
    p "Llamada actual por #{current_call} con un TS de #{current_call_ts}"

    case
    when user == current_call
      false
    when current_call == last_call
      minutes = current_call_ts - last_call_ts
      true if minutes >= 400
    else
      true
    end

  end

  def update_coins(user, type, data)
    coins = check_coins(user)
    new_coins = resolve(coins, type)

    p coins
    p new_coins

    firebase = client
    firebase.update('enercoin',
                    "#{user}/coin" => new_coins,
                    "#{user}/user" => data.user,
                    "#{user}/ts" => data.ts) if secure_coins(user, data)
    check_coins(user)
  end
end
