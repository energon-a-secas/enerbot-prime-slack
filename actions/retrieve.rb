require './mind/memory'
require './voice'

### help: dame un beneficio --- Enerbot te asignará un beneficio.
module RetrieveBenefit
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('benefits')
    normal_talk(doc, data)
  end
end

### help: dame feedback || dale feedback a *< @user_1 >* como *< @user2 >* --- Realiza evaluaciones de desempeño de forma completamente legal.
module RetrieveFeedback
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('feedbacks')
    client = configure_client('web')

    target = ''
    replace = ''
    if (match = data.text.match(/<@(.*?)>\s(como|as)\s<@(.*?)>/i))
      target = match.captures[0]
      replace = match.captures[2]
    end
    if target != '' && replace != ''
      c = client.users_info user: replace
      ENV['SLACK_BOT_ICON'] = c.user.profile.image_512
      ENV['SLACK_BOT_NAME'] = c.user.real_name
      doc = "*<@#{target}>*: #{doc}"
      normal_talk(doc, data)
      ENV['SLACK_BOT_ICON'] = 'https://i.imgur.com/1n1Uohi.png'
      ENV['SLACK_BOT_NAME'] = 'ENERBOT'
    else
      normal_talk(doc, data)
    end
  end
end

### help: dame una excusa --- Enerbot usará su ML para figurar una excusa plausible.
module RetrieveExcuse
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('excuses')
    normal_talk(doc, data)
  end
end

### help: *< dame | tira | tirate>* *< un | una >* *< versiculo | cita biblica | biblia >* --- Recuerda, en ENERGON no preguntamos "¿Para qué?" sino ¿Por cuánto?.
module RetrieveBible
  extend FirebaseOps
  extend Voice

  # https://i.imgur.com/wxEBkqY.png

  def self.exec(data)
    doc = get_col('bible')
    c_icon = ENV['SLACK_BOT_ICON']
    p c_icon
    ENV['SLACK_BOT_ICON'] = 'https://i.imgur.com/wxEBkqY.png'
    ENV['SLACK_BOT_NAME'] = 'Enerbowitz'
    normal_talk(doc, data)
    ENV['SLACK_BOT_ICON'] = c_icon
    ENV['SLACK_BOT_NAME'] = 'ENERBOT'
  end
end

### help: dame una frase para el bronce --- Enerbot compartirá parte de la sabiduría popular.
module RetrieveBronce
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('bronzes')
    normal_talk(doc, data)
  end
end

### help: dame un consejo *< pregunta >* --- Enerbot te puede guiar en el camino de la iluminación espiritual.
module RetrieveAdvice
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('advices')
    normal_talk(doc, data)
  end
end

### help: dame un mas --- Enerbot te dirá una comparación "a la chilena".
module RetrieveMore
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('morethan')
    normal_talk(doc, data)
  end
end

### help: tirate una paya --- Enerbot tirará una paya.
module RetrievePaya
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = "\n:chile::chile::chile:\n>>>#{get_col('paya')}"
    normal_talk(doc, data)
  end
end

### help: dame un chiste de meruane || dame un buen chiste --- Enerbot compartirá el mejor humor conocido.
module RetrieveMeruane
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('meruane')
    normal_talk(doc, data)
  end
end

### help: dame una polemica <sfw | nsfw | safe (default)> --- Enerbot tirará una frase polemica.
module RetrievePolemica
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    safe = get_col('polemica')

    nsfw = ['¿Has pasado fotos desnudo o desnuda por Whatsapp?', '¿Has pensado en alguna otra personas mientras tenias relaciones íntimas con tu pareja?', '¿Has tenido un encuentro íntimo con alguien a a quien hayas conocido ese mismo día?', '¿Cuánto tiempo duró la relación amorosa más breve que has tenido?', '¿Cuál ha sido el sitio más curioso donde has mantenido relaciones?', '¿Te han descubierto tus padres en la cama con alguien?', '¿Has sido pillado manteniendo relaciones sexuales?', '¿Qué harías si te encontraras sin papel en un baño público?', 'Si al morir te incineraran, a que olerían tus cenizas', '¿Cuál es la mayor locura que has hecho?', '¿Tienes alguna manía en la cama?']
    sfw = ['¿Que parte de tu cuerpo te gusta mas y por qué?', 'Papas fritas con mayo o con ketchup.', '¿Cuánto es el máximo tiempo que has pasado sin ducharte?', '¿Has visto a algun Glober desnudo?', 'Si pudieras ser un personaje del chavo del , cual serias y por qué.', '¿Te beberías tu propia orina si estuvieras en mitad del desierto y qué sabor tendría?', '¿A qué edad de tu vida te gustaría regresar y por qué?', '¿Qué es lo primero harías si fueras invisible?', '¿Cuándo fue la última vez que mentiste?', '¿Cuál es la última mentira que has contado?', '¿Cuál es el momento en que has sentido más dolor físico en tu vida?', 'Si pudieras viajar en el tiemp, ¿viajarías al pasado o al futuro?', '¿Crees que hay vida en otros planetas del universo?', 'Perros o gatos', 'Que opinas de la pizza con piña?', '¿En qué época te hubiese gustado vivir?', 'Si un oso te atacar, ¿qué harías para sobrevivir?', '¿Qué es lo más vergonzoso que te han pillado haciendo?', '¿Qué es lo que te pone más nervioso?', '¿Alguna vez se te ha roto el móvil? ¿Cómo fue?', '¿Qué es lo más raro que has visto en casa de alguien?', '¿Qué es lo más raro que ha hecho alguien en tu casa?', "Termina la frase: 'No podría vivir en una casa que no tuviera...'", 'Si pudieses saber sólo una cosa del futur, ¿qué preguntarías?', '¿Alguna vez te han pateado por mensaje?', 'Si fueses un dinosauri, ¿cuál te gustaría ser? ¿por qué?']
    mode = case data.text
           when /nsfw/
             if ENV['SLACK_NSFW'] =~ /locked/
               'No hay autorización para este modo, consulte con el gerente de ventas de ENERGON más cercano.'
             else
               nsfw.sample
             end
           when /sfw/
             sfw.sample
           else
             safe
           end
    normal_talk(mode, data)
  end
end

### help: dame un refrán --- Enerbot tirará un refrán para reflexionar.
module RetrieveRefran
  extend FirebaseOps
  extend Voice

  def self.exec(data)
    doc = get_col('refran')
    normal_talk(doc, data)
  end
end
