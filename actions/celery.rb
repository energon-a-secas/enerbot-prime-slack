require './voice'
require './senses/sight'

### help: *< celery | tayne | oyster | hat wobble | flarhgunnstow | 4d3d3d3 >* --- Deberías saber que significa cada una de estas funciones.
### help: *< oyster >* *< yes | no >* --- Activa el modo interactivo Celery.
module CeleryMan
  extend Voice
  extend Slack_history

  def talk(chat, data)
    chat.each_line do |line|
      sleep(1)
      normal_talk(line, data)
    end
  end

  def self.exec(data)
    case data.text
    when /celery/i
      'https://i.imgur.com/6MqOJUg.gif'
    when /tayne/i
      'https://i.gifer.com/3zzS.gif'
    when /(hat wobble|flarhgunnstow)/i
      'https://i.imgur.com/SOlzkvP.gif'
    when /4d3d3d3/i
      'http://i.imgur.com/noJWe.gif'
    when /oyster/i
      normal_talk('https://i.gifer.com/4fwu.gif', data)
      sleep(1)
      cinco = ":terminal: *I have a BETA sequence*\n:terminal: *I have been working on*\n:terminal: *Would you like to see it?*"
      sleep(2)
      cinco.each_line do |line|
        sleep(1)
        normal_talk(line, data)
      end
      begin
        message = last_message('text', data.channel, 1, 'groups')
        user = last_message('user', data.channel, 1, 'groups')
        p user
      end until message =~ /(no|yes)/ && data.user == user
      text = if message.include? 'yes'
               'https://i.gifer.com/3zzS.gif'
             else
               'ok'
             end
      normal_talk(text, data)
    end
  end
end
