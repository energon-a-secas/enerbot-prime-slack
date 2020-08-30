require './lib/search_slack'

# Altered Images
module ImageSlack
  def imitate_look(user)
    c = get_user_info(user)
    # c.profile.real_name
    name = c.profile.display_name
    image = c.profile.image_512
    event_look_set(name, image)
  end

  def event_look_set(name, image)
    ENV['SLACK_BOT_ICON'] = image
    ENV['SLACK_BOT_NAME'] = name
  end

  def event_look_revert
    ENV['SLACK_BOT_ICON'] = 'https://i.imgur.com/1n1Uohi.png'
    ENV['SLACK_BOT_NAME'] = 'Enerbot'
  end
end
