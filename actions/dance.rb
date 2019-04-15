require './talk'

# When there's nothing to say, say something
module Dance
  def self.disco(chan)
    type = ['https://imgur.com/gallery/pAlNA0x'].sample
    text = ['Hey! Hey! Check me out, IM DANCIN IM DANCIN!',
            'Commencing directive three! Uhntssuhntssuhntss--',
            'Everybody, dance time! Da-da-da-dun-daaa-da-da-da-dun-daaa!'].sample
    Speech.normal("#{text} #{type}", chan)
  end
end
