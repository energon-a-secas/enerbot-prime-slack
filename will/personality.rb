module Character
end

module Persona
  def event_look_set(name, image)
    ENV['SLACK_BOT_ICON'] = image
    ENV['SLACK_BOT_NAME'] = name
  end

  def event_look_revert
    ENV['SLACK_BOT_ICON'] = 'https://i.imgur.com/1n1Uohi.png'
    ENV['SLACK_BOT_NAME'] = 'ENERBOT'
  end
end
