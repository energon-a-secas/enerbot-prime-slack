require 'google/cloud/firestore'

# Modules for Firestore operations
module FirebaseOps
  def new_client
    Google::Cloud::Firestore.new
  end

  def get_data(path, db = 'enercoins')
    firestore = new_client
    document = firestore.doc "#{db}/#{path}"
    document.get
  end

  def get_col(collection)
    firestore = new_client
    quote_col = firestore.col(collection)
    quotes = []
    quote_col.get { |entry| quotes << entry[:texto] }
    quotes.sample
  end

  def update_data(user, coins = 0, type = 0, motive = 0, slack_user = 0, slack_ts = 0)
    ts = Time.now.strftime('%s')
    firestore = new_client

    coins_update = firestore.doc("enercoins/#{user}")
    coins_update.set('coin' => coins,
                     'slack_user' => slack_user,
                     'slack_ts' => slack_ts)

    history_update = firestore.doc("enercoins/#{user}/history/#{ts}")
    history_update.set("history/#{ts}/action" => type,
                       "history/#{ts}/user" => slack_user,
                       "history/#{ts}/motive" => motive)
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
    update_data(user) if account.missing?
    get_data(user)[:coin]
  end

  def check_permissions(user, current_call, current_call_ts, channel)
    last_call = get_data(user)[:slack_user]
    last_call_ts = get_data(user)[:slack_ts].to_i
    minutes = current_call_ts - last_call_ts
    time_to_wait = 120
    time_now = Time.at(time_to_wait - minutes).strftime('%M:%S')

    # "Ultima llamada por #{last_call} con un TS de #{last_call_ts}"
    # "Llamada actual por #{current_call} con un TS de #{current_call_ts}"

    if user == current_call
      [false, ":bank: *Restricted Transaction* on <##{channel}|S3CR3T>. Just no <@#{user}> :peyo2:"]
    elsif current_call == last_call
      if minutes <= time_to_wait
        [false, ":bank: *Restricted Transaction* from <@#{current_call}> on <##{channel}|S3CR3T>. *[ENER-200]*: Too many requests."] # ":clock1: #{time_now}"]
      else
        [true, ":bank: *Approved transaction* from <@#{current_call}> on <##{channel}|S3CR3T>. <@#{user}> now has "]
      end
    else
      [true, ":bank: *Approved transaction* on #{channel}, <@#{user}> final balance "]
    end
  end

  def update_coins(user, type, motive, data)
    current_coins = check_account(user)
    updated_coins = new_balance(current_coins, type)
    approved_transaction, text = check_permissions(user, data.user, data.ts.to_i, data.channel)

    if approved_transaction
      update_data(user, updated_coins, type, motive, data.user, data.ts)
    end
    [updated_coins, text, approved_transaction]
  end
end
