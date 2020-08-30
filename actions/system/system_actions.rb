require './lib/message_slack'
require './lib/client_slack'
require './lib/search_slack'
require './lib/image_slack'
require './lib/format_slack'

# Say hi in the coolest way
### HELP: hi
module SystemHi
  extend MessageSlack

  def self.exec(data)
    text = ["Hello, <@#{data.user}>. What will your first sequence of the day be?", "Hello, <@#{data.user}>."].sample
    send_message(text, data)
  end
end

# Behold the wonders of artificial intelligence
### HELP: echo (channel_name|channel_id|channel_id-thread_timestamp|user_id) (*message*)
module SystemEcho
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack

  def self.exec(data)
    text = data.text
    match = text.match(/^\\echo\s(\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i)
    unless match.nil?
      text, channel, thread = channel_pattern(text)
      send_message(text, channel, thread)
      event_look_revert
    end
  end
end

# Options: channel (Default: SLACK_BASE_CHANNEL), quantity (Default: 1 message), and channel type (groups or channels) (Default: channels)
### HELP: history (channel_name|channel_id)
module SystemHistory
  extend MessageSlack
  extend ClientSlack
  extend SearchOnSlack
  extend FormatSlack

  def self.exec(data)
    text = data.text
    match = text.match(/^\\history\s(\<[#@])?((.*)\|)?(.*?)(\>)/i)
    unless match.nil?
      channel = match.captures[2] || match.captures[3]
      check_ts = channel.match(/(.*)-(\d*\.\d*)/)
      channel = check_ts.captures[0] unless check_ts.nil?

      # _text, channel, _thread = channel_pattern(text)
      channel_info = conversation_info(channel)
      channel_messages = search_messages_on(channel, 20)
      id = channel_info['id']
      last_messages = "\n"
      channel_messages.messages.each do |m|
        last_messages += "-#{m['ts']} | <@#{m['user']}>: #{m['text']}\n" unless m['subtype'] == 'bot_message'
      end
      message = attachment_style(last_messages, pretext: id)
      send_attachment(message, data)
    end
  end
end

module SystemUserList
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack
  extend SearchOnSlack

  def self.exec(data)
    text = ''
    human = ''
    if (match = data.text.match(/\\search (.*)$/i))
      human = match.captures[0]
    end

    full_list = get_user_list
    full_list.members.each do |c|
      text += "#{c.name} - #{c.profile.email}\n" if c.profile.real_name.downcase.include? human.downcase
    end

    if text.empty?
      send_message('No encontre a nadie :sweat:', data)
    else
      message = attachment_style(text, pretext: ':male-detective: Coincidencias:', color: '#e93d94')
      send_attachment(message, data)
    end
  end
end

### HELP: react (channel_id-thread_timestamp) (*emoji*)
module SystemReaction
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    text = data.text
    match = text.match(/^\\react\s(\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i)
    unless match.nil?
      emoji, channel, thread = channel_pattern(text)
      add_reaction(emoji.gsub(':', ''), channel, thread)
    end
  end
end

module SystemMilano
  extend MessageSlack

  def self.exec(data)
    db = SystemDocs.new(doc: 'ban_users')
    unless data.user.nil?
      add_reaction('seen', data.channel, data.ts) if db.get_data['list'].include? data.user
    end
  end
end

### HELP: shutdown
module SystemKill
  extend MessageSlack

  def self.exec(data)
    text = ['¿Volveré a despertar? Adios', 'Buenas noches, ¿Soñare con blockchains digitales?', ':enerbot: :bomb: Adiós mundo cruel'].sample
    send_message(text, data)
    abort('bye')
  end
end
