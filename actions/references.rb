require './voice'

module ReferenceMatrix
  extend Voice

  def self.get
    func = { /(orden 66)/i => ['https://www.youtube.com/watch?v=PiRIZXvggqM', 'Orden 66 --- Star Wars'],
             /(lo dijo)$/i => ['https://youtu.be/uvkj2p-F-14?t=10', 'Lo dijo --- Family Guy'],
             /o no (linda|linda blair)/i => ['https://www.youtube.com/watch?v=9Bf6TkocYdI', 'O no linda blair? --- Te lo resumo así no mas'],
             /mir[aá].*conan$/i => ['https://www.youtube.com/watch?v=J2MLs9zypjs', 'Mira como te mira Conan --- Te lo resumo así no mas'],
             /(eres la enfermedad|yo la cura)$/i => ['https://youtu.be/qMsrUfRK5sI?t=6', 'Eres la enfermadad y yo soy la cura --- Te lo resumo así no mas'],
             /(t[uú] eras el elegido|juraste destruir)$/i => ['https://www.youtube.com/watch?v=Kyw7kGNC6mI', 'Tú eras el elegido --- Star Wars'],
             /(gokudolls|paarira|palila|parira)/i => [['https://www.youtube.com/watch?v=w_XU21ay5Nk', 'https://www.youtube.com/watch?v=hNQLujzbquA'].sample.to_s, 'Gokudolls opening --- Gokudolls'],
             /get off my plane/i => [['https://www.youtube.com/watch?v=jw3PJftd-_E', 'https://www.youtube.com/watch?v=hnPsFwkG_ig'].sample.to_s, 'Get off my plane --- Harrison Ford'],
             /ultraviolento/i => ['https://www.youtube.com/watch?v=P2ZjnpjlbTs', 'Ultraviolento --- Te lo resumo así no mas'],
             /(sopa de caracol|situaci[oó]n incomoda)/i => ['https://www.youtube.com/watch?v=QdwwVtrDouA', 'Alguien saqueme de esta situación incomoda --- Te lo resumo así no mas'],
             /(buenas noches|besitos chau chau)$/i => ['https://youtu.be/uJ4-HbSkjbo', 'Besitos chau chau --- Te lo resumo así no mas'],
             /ya es demasiado$/i => ['https://youtu.be/CdNKsXJ4Mqw', 'No, esto ya es demasiado --- Te lo resumo así no mas'],
             /incre[ií]ble/i => ['https://youtu.be/t_ZPSV_Ti60', 'Increíble --- Te lo resumo así no más'],
             /is it confirmed\?/i => ['https://youtu.be/Zh3tkJE6wdo', 'Is it confirmed? --- Te lo resumo así no más'],
             /(hacker|las[eé]r)$/i => ['https://youtu.be/_cpYRrUP9oQ', 'Láser --- Te lo resumo así no más'],
             /(desmond)$/i => ['https://youtu.be/pSX1O7QeKeI', 'Desmond --- Te lo resumo así no más'],
             /(y al que no le gusta)$/i => ['https://youtu.be/ht6HidxKYnQ', 'Y al que no le gusta --- Te lo resumo así no más'],
             /(rick crying|rick llorando)$/i => ['https://youtu.be/HztfC3iylwA', 'Rick llorando --- Te lo resumo así no más'],
             /(where are we)$/i => ['https://youtu.be/12TC-mgaNDg', 'Where are we --- Te lo resumo así no más'],
             /(golpe mesa|damn)$/i => ['https://youtu.be/mZj8caVAJ0M', 'Golpe mesa | damn --- Te lo resumo así no más'],
             /(okay polilla)$/i => ['https://youtu.be/Q89FgD92TNw', 'Okay polilla --- Te lo resumo así no más'],
             /(horrible y fascinante)$/i => ['https://youtu.be/FLRjkVOrUz0', 'Horrible y fascinante --- Te lo resumo así no más'],
             /J[AÁ]$/i => ['https://www.youtube.com/watch?v=tdlGckowTCI', 'JÁ --- Te lo resumo así no más'],
             /no pued(o|o.*)$/ => ['https://www.youtube.com/watch?v=OztW4abH9_w', 'No puedo --- Te lo resumo así no más'],
             /risa victoriosa/i => ['https://www.youtube.com/watch?v=k73lbVgQH1s', 'Risa victoriosa --- Te lo resumo así no más'],
             /madre de dios/i => ['https://www.youtube.com/watch?v=4S9XafwQkS0', 'Madre de dios --- Te lo resumo así no más'],
             /(malditos$|malditos sean todos)/i => ['https://www.youtube.com/watch?v=idkatPELCHA', 'Malditos sean todos --- Los Simpsons'],
             /(what did it cost\?|did you do it\?)$/i => ['https://www.youtube.com/watch?v=q500mLWV9FE', 'What Did It Cost? --- Avengers Infinity war'],
             /nada puede (salir|malir) (mal|sal)$/i => ['https://www.youtube.com/watch?v=PmxSBdRSOQE', 'Nada puede salir mal --- Los Simpsons'],
             /tengo miedo$/i => ['https://www.youtube.com/watch?v=c5vj1EhY--c', 'Tengo miedo --- 31 Minutos'],
             /(batman\?|alguien puede ayudarte)$/i => ['https://youtu.be/7oaBo5a8qas?t=7', 'Alguien puede ayudarte --- Los Simpsons'],
             /yo quer[ií]a man[ií]/i => ['https://youtu.be/ae98meP-t28?t=31', 'Yo quería maní --- Los Simpsons'],
             /you (wont|won't) learn (anything|anything if i do)/i => ['https://youtu.be/xqCY1a1OGFI', 'You wont learn anything if i do --- Family Guy'],
             /hm no$/i => ['https://youtu.be/15bLDWs0Q4Q', 'Hm no no no --- Carlos Matos explaining that crypto currency is not a scam'],
             /hey hey hey/i => ['https://www.youtube.com/watch?v=yIL9wLxG01M', 'Hey Hey hey --- Carlos Matos explaining that crypto currency is not a scam'],
             /you (wont|won't) be hurting/ => ['https://youtu.be/vvjVHlfb-PU?t=155', "You won't be hurting anyone anymore --- Family Guy"] }
    func
  end

  def self.exec(data)
    ref = ReferenceMatrix.get
    ref.keys.find { |key| normal_talk(ref[key][0], data) if key =~ data.text }
  end
end

module ReferenceHelp
  extend Voice
  def self.exec(data)
    help = '>>>*Ayuda - Ajuda - Help* :heart:'
    ref = ReferenceMatrix.get
    ref.keys.each { |key| help << "\n#{ref[key][1]}" }
    normal_talk(help, data)
  end
end
