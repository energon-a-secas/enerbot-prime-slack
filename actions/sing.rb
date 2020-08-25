require './voice'

### help: *< sing | canta >*
module SingSong
  def self.exec(data)
    extend Voice
    song = ["Perhaps love is like a resting place, a shelter from the storm\nIt exists to give you comfort, it is there to keep you warm\nAnd in those times of trouble when you are most alone\nThe memory of love will bring you home\n",
            "Ra ra Rasputin\nLover of the Russian queen\nThere was a cat that really was gone\nRa ra Rasputin\nRussia's greatest love machine\nIt was a shame how he carried on",
            "Mama, just killed a man\nPut a gun against his head\nPulled my trigger, now he's dead\nMama, life had just begun\nBut now I've gone and thrown it all away",
            "Let's get loud, let's get loud\nTurn the music up, let's do it\nC'mon people let's get loud\nLet's get loud\nTurn the music up to hear that sound\nLet's get loud, let's get loud\nAin't nobody gotta tell ya\nWhat you gotta do"].sample
    song.each_line do |line|
      sleep(1)
      normal_talk(line, data)
    end
  end
end

### help: recomienda una canción
module RecommendSong
  def self.exec(data)
    extend Voice
    song = ['https://youtu.be/Q91hydQRGyM', 'https://youtu.be/GuJQSAiODqI', 'https://youtu.be/KiRyiVgWj6g',
            'https://youtu.be/toYfeN0ACDw', 'https://youtu.be/Lrle0x_DHBM', 'https://youtu.be/QtxlCsVKkvY',
            'https://youtu.be/3GwjfUFyY6M', 'https://youtu.be/x9IimLb3b2U'].sample

    comment = ['Let me think... this one',
               'I would recommend this one',
               'Okay'].sample

    normal_talk("#{comment} #{song}", data)
  end
end
