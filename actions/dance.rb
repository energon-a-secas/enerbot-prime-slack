require './voice'

# When there's nothing to say, say something
module Dance
  extend Voice
  def self.disco(data)
    type = ['https://imgur.com/gallery/pAlNA0x'].sample
    text = ['Hey! Hey! Check me out, IM DANCIN IM DANCIN!',
            'Commencing directive three! Uhntssuhntssuhntss--',
            'Everybody, dance time! Da-da-da-dun-daaa-da-da-da-dun-daaa!'].sample
    normal_talk("#{text} #{type}", data)
  end
end
