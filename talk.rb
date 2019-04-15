require 'slack-ruby-client'

# IT JUST WORKS
module Speech
  Slack.configure do |config|
    config.token = ENV['CL4P_API_TOKEN']
    config.raise 'Missing Bot token' unless config.token
  end

  @client = Slack::RealTime::Client.new

  def self.normal(text, channel, thread = '')
    @client.web_client.chat_postMessage channel: channel,
                                        text: text,
                                        icon_url: 'http://www.fritzhardy.com/games/borderlands_2_ps3/E19655605689AC6A24D6C76039CF748B4493BA1B.PNG',
                                        username: 'CL4P-TP',
                                        thread_ts: thread
  end
end
