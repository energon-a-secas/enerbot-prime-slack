require 'firebase'

module FirebaseOps

  def new_client
    key = File.open('./config/firebase.json').read
    Firebase::Client.new(ENV['FIREBASE_ENDPOINT'], key)
  end

  def get_data(user, path = '')
    firebase = new_client
    firebase.get("enercoin/#{user}/#{path}").body
  end

  def update_data(user, coins = 0, type = 0, motive = 0, slack_user = 0, slack_ts = 0)
    ts = Time.now.strftime('%s')
    firebase = new_client
    update = firebase.update('enercoin',
                             "#{user}/coin" => coins,
                             "#{user}/user" => slack_user,
                             "#{user}/history/#{ts}/action" => type,
                             "#{user}/history/#{ts}/motive" => motive,
                             "#{user}/ts" => slack_ts)
    update.success?
  end

  def new_balance(coins, action)
    case action
    when '++' then coins + 1
    when '--' then coins - 1
    else
      coins
    end
  end

  def check_account(user)
    account = get_data(user)
    update_data(user) if account.nil?
    get_data(user, 'coin')
  end

  def check_permissions(user, slack_user, slack_ts)
    last_call = get_data(user, 'user')
    last_call_ts = get_data(user, 'ts').to_i
    current_call = slack_user
    current_call_ts = slack_ts
    minutes = current_call_ts - last_call_ts

    p "Ultima llamada por #{last_call} con un TS de #{last_call_ts}"
    p "Llamada actual por #{current_call} con un TS de #{current_call_ts}"
    p "#{last_call_ts} - #{current_call_ts} = #{current_call_ts - last_call_ts}"
    p minutes
    case
    when user == current_call
      [false, ':bank: No puedes darte enercoins a ti mismo :peyo:']
    when current_call == last_call
      if minutes <= 300
        [false, ":bank: No puedes hacer tantas transacciones... gratis. Tiempo en fila #{Time.at(minutes).strftime("%M:%S")}-05:00 :clock1:"]
      else
        [true, ":bank: Enercoins actualizados, <@#{user}> ahora tiene "]
      end
    else
      [true, ":bank: Enercoins actualizados, <@#{user}> ahora tiene "]
    end
  end

  def update_coins(user, type, motive, data)
    current_coins = check_account(user)
    updated_coins = new_balance(current_coins, type)
    approved_transaction, text = check_permissions(user, data.user, data.ts.to_i)

    check = update_data(user, updated_coins, type, motive, data.user, data.ts) if approved_transaction
    p check
    if check == true
      [updated_coins, "#{text}"]
    else
      [nil, text]
    end
  end
end