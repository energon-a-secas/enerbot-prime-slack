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

# module SystemEnerStar
#   extend SearchOnSlack
#   extend MessageSlack
#
#   def self.exec(data)
#     random_list = conversation_members('CCTS6BQD9', 450) - ['U018HFXTQ5D']
#     user = random_list.sample
#     type = %w[bk ci eiy hf i&d tb tp].sample
#     command = '/starmeup'
#     arguments = "#{type} <@#{user}> This star is sponsored by ENERGON and Enerbot. #{Time.now}"
#     p arguments
#     message = send_command(command, arguments, '#g-o-scl-havefun')
#     p message
#     if message.ok == true
#       send_message("Hooray! Your :star: to *<@#{user}>* was sent successfully", data)
#     else
#       send_message('HOUSTON WE HAVE A PROBLEM!', data)
#     end
#   end
# end

### HELP: (automatic)
module SystemReject
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    user = hyper_text_pattern(data.text)
    channel = hyper_text_pattern(data.text, 'channel_fix')
    text = "El usuario #{user} me ha matado, volveré pero tomará tiempo el respawn.\nQuiero su cabeza en una bandeja antes de que termine el día. Cambio."
    last_message = send_message(text, channel)
    send_message('https://i.imgur.com/3StLBsj.jpg', last_message.channel, last_message.message.ts)
  end
end

# Behold the wonders of artificial intelligence
### HELP: echo (channel_name|channel_id|channel_id-thread_timestamp|user_id) (*message*)
module SystemEcho
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack
  extend SearchOnSlack

  def self.exec(data)
    text = data.text
    match = text.match(/^\\(echo|dm)/i)
    unless match.nil?
      text, channel, thread = channel_pattern(text)
      user_is_channel = get_user_id(channel)
      if user_is_channel == false
        send_message(text, channel, thread)
      else
        send_direct_message(text, channel)
      end
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

    num = text.match(/\s(\d{1,3})$/)
    text += ' 3' if num.nil?
    match = text.match(/^\\history\s(\<[#@])?((.*)\|)?(.*?)(\>)/i)
    unless match.nil?
      quantity, channel, _thread = channel_pattern(text)
      channel_info = conversation_info(channel)
      channel_messages = search_messages_on(channel, quantity.to_i)
      last_messages = "\n"
      channel_messages.messages.each do |m|
        last_messages += "#{channel_info['id']}-#{m['ts']} | <@#{m['user']}>: #{m['text']}\n"
      end
      message = attachment_style(last_messages, pretext: '\history')
      send_attachment(message, data)
    end
  end
end

module SystemLastEvent
  extend MessageSlack
  extend ClientSlack
  extend SearchOnSlack
  extend FormatSlack

  def self.exec(data)
    text = data.respond_to?(:text) ? data.text : data
    match = text.match(/ (.*)? (.*)?$/i)
    if match.nil?
      default = case text
                when /sreact/
                  'joy'
                when /secho/
                  'Meh'
                end

      text += " #{default}"
    end

    match = text.match(/(<[#@])?((.*)\|)?(.*?)(\>)? (.*)?$/i)

    unless match.nil?
      element, channel, _thread = channel_pattern(text)
      channel_messages = search_messages_on(channel, 1)
      channel_ts = channel_messages.messages[0]['ts']

      case text
      when /secho/

        send_message(element, channel, channel_ts)
      when /sreact/
        add_reaction(element.gsub(':', ''), channel, channel_ts)
      end
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

### HELP: nsfw (unlock|lock)
module SystemNSFW
  extend MessageSlack

  def self.exec(data)
    ENV['SLACK_NSFW'] = if data.text.include? 'unlock'
                          'open'
                        else
                          'locked'
                         end
    send_message(":fire: *NSFW* pasa a estado #{ENV['SLACK_NSFW']}", data)
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
