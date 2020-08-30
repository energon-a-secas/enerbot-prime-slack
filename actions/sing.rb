require './lib/message_slack'

### ENERBOT: canta --- Enerbot cantará un extracto de sus canciones favoritas.
module SingSong
  def self.exec(data)
    extend MessageSlack
    song = ["Perhaps love is like a resting place, a shelter from the storm\nIt exists to give you comfort, it is there to keep you warm\nAnd in those times of trouble when you are most alone\nThe memory of love will bring you home\n",
            "Ra ra Rasputin\nLover of the Russian queen\nThere was a cat that really was gone\nRa ra Rasputin\nRussia's greatest love machine\nIt was a shame how he carried on",
            "Mama, just killed a man\nPut a gun against his head\nPulled my trigger, now he's dead\nMama, life had just begun\nBut now I've gone and thrown it all away",
            "Let's get loud, let's get loud\nTurn the music up, let's do it\nC'mon people let's get loud\nLet's get loud\nTurn the music up to hear that sound\nLet's get loud, let's get loud\nAin't nobody gotta tell ya\nWhat you gotta do"].sample
    song.each_line do |line|
      sleep(1)
      send_message(line, data)
    end
  end
end

### ENERBOT: recomienda una canción --- Mandará un video aleatorio.
module RecommendSong
  def self.exec(data)
    extend MessageSlack
    song = %w[Q91hydQRGyM GuJQSAiODqI KiRyiVgWj6g toYfeN0ACDw Lrle0x_DHBM QtxlCsVKkvY 3GwjfUFyY6M x9IimLb3b2U].sample
    comment = ['Let me think... this one', 'I would recommend this one', 'Okay'].sample

    send_message("#{comment}\nhttps://youtu.be/#{song}", data)
  end
end
