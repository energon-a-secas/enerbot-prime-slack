require './voice'
require './senses/sight'

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
      cinco = ">I have a BETA sequence\n>I have been working on\n>Would you like to see it?"
      sleep(2)
      cinco.each_line do |line|
        sleep(1)
        normal_talk(line, data)
      end
      sleep(3)
      resp = last_message('text', data.channel, 1, 'groups')
      p resp
      text = if resp.include? 'yes'
               'https://i.gifer.com/3zzS.gif'
             else
               'ok'
             end
      normal_talk(text, data)
    end
  end
end