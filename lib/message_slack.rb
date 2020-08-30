require_relative 'client_slack'
require_relative 'search_slack'

# Communication and interactions methods with Slack
module MessageSlack
  include ClientSlack
  include SearchOnSlack

  def destination_points(data, ts = nil)
    @thread = if data.respond_to? :thread_ts
                data.ts
              else
                ts unless ts.nil?
              end
    @channel = if data.respond_to? :channel
                 data.channel
               else
                 data
               end
  end

  def send_message(text, data, ts = nil)
    client = configure_client
    destination_points(data, ts)
    client.chat_postMessage channel: @channel,
                            text: text,
                            icon_url: ENV['SLACK_BOT_ICON'],
                            username: ENV['SLACK_BOT_NAME'],
                            thread_ts: @thread
  rescue Slack::Web::Api::Errors::SlackError => e
    print e.message
    false
  end

  def send_direct_message(text, channel)
    dm = get_user_id(channel)
    dm == false ? false : send_message(text, dm)
  end

  def send_attachment(attachment, data, ts = nil)
    client = configure_client
    destination_points(data, ts)
    client.chat_postMessage channel: @channel,
                            attachments: attachment,
                            icon_url: ENV['SLACK_BOT_ICON'],
                            username: ENV['SLACK_BOT_NAME'],
                            thread_ts: @thread
  rescue Slack::Web::Api::Errors::SlackError => e
    print e.message
    false
  end

  def add_reaction(icon, channel, thread)
    client = configure_client
    client.reactions_add channel: channel,
                         name: icon,
                         timestamp: thread,
                         icon_url: ENV['SLACK_BOT_ICON'],
                         username: ENV['SLACK_BOT_NAME']
  rescue Slack::Web::Api::Errors::SlackError => e
    print e.message
    false
  end
end
