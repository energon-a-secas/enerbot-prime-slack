require './lib/search_slack'

# Obtains data of user from Slack and then uses them to mimic looks.
module ImageSlack
  def imitate_look(user)
    c = get_user_info(user)
    name = c.profile.display_name
    image = c.profile.image_512
    event_look_set(name, image)
  end

  def event_look_set(name, image)
    ENV['SLACK_BOT_ICON'] = image
    ENV['SLACK_BOT_NAME'] = name
  end

  def event_look_revert
    ENV['SLACK_BOT_ICON'] = 'https://i.imgur.com/yaGNTBb.png' # 'https://ca.slack-edge.com/T02CTQY6K-UEET8LAHX-d328f4d5b371-512'
    ENV['SLACK_BOT_NAME'] = 'Enerbot'
  end
end
