require 'yt'
require './lib/message_slack'

### HELP: busca (*video*) --- Busca y trae un video de youtube.
module YoutubeSearch
  extend MessageSlack

  def self.exec(data)
    Yt.configure do |config|
      config.api_key = ENV['YOUTUBE_API_KEY']
    end
    text = data.text.gsub('enerbot busca ', '')

    videos = Yt::Collections::Videos.new
    result = videos.where(q: text).first
    send_message("https://www.youtube.com/watch?v=#{result.id}", data)
  rescue StandardError => e
    cat = ['https://youtu.be/Imeq3GeRttw'].sample
    text = "No encontré un video, así que te dejaré un video de gatos para distraerte: #{cat}"
    send_message(text, data)
  end
end
