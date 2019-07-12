# frozen_string_literal: true

# Firebase methods
require 'firebase'
require './voice'

module FireOps
  include Voice
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

    if user == current_call
      [false, ':bank: No puedes darte enercoins a ti mismo :peyo:']
    elsif current_call == last_call
      minutes = current_call_ts - last_call_ts
      if minutes >= 400
                [true, '']
              else
                [false, ":bank: Tienes que esperar un rato antes de poder dar más Enercoins"]
              end
    else
      [true, ":bank: Balance de EnerCoins: #{check_coins(user) + 1}"]
    end
  end

  def update_coins(user, type, motive, data)
    coins = check_coins(user)
    new_coins = resolve(coins, type)

    ts = Time.now.strftime('%s')
    firebase = client
    check, text = secure_coins(user, data)
    if check
      firebase.update('enercoin',
                      "#{user}/coin" => new_coins,
                      "#{user}/user" => data.user,
                      "#{user}/history/#{ts}/action" => type,
                      "#{user}/history/#{ts}/motive" => motive,
                      "#{user}/ts" => data.ts)
    end

    normal_talk(text, data)

  end
end
