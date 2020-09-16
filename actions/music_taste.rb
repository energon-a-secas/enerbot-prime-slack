require './lib/message_slack'

### ENERBOT: canta --- Enerbot cantará un extracto de sus canciones favoritas.
module SingSong
  extend MessageSlack

  def self.exec(data)
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

require './lib/message_slack'

### ENERBOT: baila --- Regresará un baile con pantalla verde.
module DiscoDance
  extend MessageSlack

  def self.exec(data)
    # KQbc2Mnb7pA
    text = %w[m6k_t8yEyvE iG1o5xLqqcY IArX33Hoxog dlsjJ2xL0sw].sample
    url = 'https://youtu.be/' + text
    send_message(url, data)
  end
end

### ENERBOT: recomienda una canción --- Mandará un video aleatorio.
module RecommendSong
  extend MessageSlack

  def self.exec(data)
    song = [
      "From R.E.M.'s 1992 album Automatic For The People: https://youtu.be/dLxpNiF0YKs",
      'How i see you all: https://youtu.be/4JkIs37a2JE',
      'https://youtu.be/Gs069dndIYk?t',
      'SOMEBODY ONCE TOLD ME: https://youtu.be/L_jWHffIx5E',
      'https://youtu.be/YVkUvmDQ3HY?t=14',
      'IS THIS A JOJO REFERENCE? https://youtu.be/ulw6tL7I6QE',
      '*NAIL*ED https://youtu.be/EmuBOfurv3o',
      'My heart and actions are utterly unclouded: https://youtu.be/CycuOJZbRvQ',
      'JOJO REFERENCE: https://youtu.be/Aq7ddhSGOSE',
      'Esta es la original, superenlo: https://youtu.be/nqxVMLVe62U',
      'Mis SLAs: https://youtu.be/dQw4w9WgXcQ',
      'I will: https://youtu.be/FHhZPp08s74',
      '¡ALELUYA! https://youtu.be/4x6leDGV7gs',
      ':fire: https://youtu.be/tJxOXzE5A8w', # Hot Stuff
      ':fire: https://youtu.be/tj1VnD-NRhw', # Disco Inferno
      ':blobdance: https://youtu.be/god7hAPv8f0', # Boogie Wonderland
      'Me dieron ganas de reiniciar el universo: https://youtu.be/171skzi5BKc',
      '*Y E S !  Y E S ! YES!! https://youtu.be/DwPWGUhEtP0',
      'D4C https://youtu.be/2V9Bjp6aJog',
      'ZAWARDO! https://youtu.be/e3RlOhqmMms',
      'https://youtu.be/LrjdpNDfZLo', # Video kill the radio star
      'https://youtu.be/FFDs0rQsaTU' # Funky Town
    ]

    send_message(song, data)
  end
end
