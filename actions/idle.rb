# frozen_string_literal: true

require './voice'

# When there's nothing to say, say something
module Idle
  extend Voice
  def self.quote(data)
    text = ["It's really quiet... and lonely... Also this 'stopped moving' thing makes me uncomfortable. It gives me time to stop and think... literally. I'VE STOPPED, AND I'M THINKING! IT HURTS ME!",
            "Oh. My. God. What if I'm like... a fish? And, if I'm not moving... I stop breathing? AND THEN I'LL DIE! HELP ME! HELP MEEEEE HEE HEE HEEE! HHHHHHHELP!",
            'Ignored again',
            'I hate stairs',
            'I love you. What? Who said that? I didn’t say anything.'].sample
    normal_talk(text, data)
  end
end
