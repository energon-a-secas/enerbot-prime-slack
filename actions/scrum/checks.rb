require './voice'
require './senses/sight'
require './will/personality'

# Check status from specified user
### SCRUM: check *< @user >* --- Entrega el estado del usuario especificado.
module ScrumCheck
  extend Voice
  extend Persona

  def self.exec(data)
    user_id = ''
    if (match = data.text.match(/<@(.*?)>/i))
      user_id = match.captures[0]
    end

    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')

    if user_id != ''
      c = UserInfo.new(user_id, data)
      text = c.get_presence
      normal_talk(text, data)
    else
      text = 'NOT FOUND'
      normal_talk(text, data)
    end

    event_look_revert
  end
end

# Check attach
module ScrumAttach
  extend Voice

  def self.exec(data, header, text, color, fallback = 'Hey listen!')
    attach = [
      {
        "author_name": header.to_s,
        "fallback": fallback.to_s,
        "color": color.to_s,
        "text": text.to_s
      }
    ]
    attachment_talk(attach, data)
  end
end
