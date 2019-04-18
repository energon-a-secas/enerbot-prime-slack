# You know, because i like the Soul Franchise
module Soul
  def configure_client(token = ENV['CL4P_API_TOKEN'])
    Slack.configure do |config|
      config.token = token
      config.raise 'Missing Bot token' unless config.token
    end

    @client = Slack::RealTime::Client.new
  end
end