require 'yt'
require './lib/message_slack'

### ENERBOT: (busca|videos de) (*video*) --- Busca y trae un video de youtube.
module YoutubeSearch
  extend MessageSlack

  def self.exec(data)
    Yt.configure do |config|
      config.api_key = ENV['YOUTUBE_API_KEY']
    end
    text = data.text.gsub(/enerbot (busca|vide(o|os) de) /, '')

    videos = Yt::Collections::Videos.new
    result = videos.where(q: text).take(3)
    message = send_message("https://youtu.be/#{result[0].id}", data)
    result.each_with_index do |v, i|
      send_message("https://youtu.be/#{v.id}", message.channel, message.ts) unless i == 0
    end
  rescue StandardError => e
    puts e.message
    video = %w[SB-qEYVdvXA ynp7O45r0s8].sample
    text = "No encontré un video, así que te dejaré un video de gatos o alguna otra mascota linda para distraerte: https://youtu.be/#{video}"
    send_message(text, data)
  end
end
