require_relative 'lib/admin_slack'
require_relative 'lib/image_slack'
require_relative 'actions/music_taste'
require_relative 'actions/responses'
require_relative 'actions/retrieve_text'
require_relative 'actions/chimuelo'
require_relative 'actions/help_menu'
require_relative 'actions/time_until_date'
require_relative 'actions/cultural_references'
require_relative 'actions/zenbot/zenbot'
require_relative 'actions/translate_text'
require_relative 'actions/quarantine_services'
require_relative 'actions/communication'
require_relative 'actions/kino'
require_relative 'actions/energon_coins/bank_teller'
require_relative 'actions/system/system_actions'
require_relative 'actions/system/system_advance'
require_relative 'actions/system/system_image'
require_relative 'actions/api_services/earthquakes'
require_relative 'actions/api_services/horoscope'
require_relative 'actions/api_services/security'
require_relative 'actions/api_services/weather_report'
require_relative 'actions/api_services/youtube_search'
require_relative 'actions/automatic_functions/emojis'
require_relative 'actions/medical_services/hospital_apis'
require_relative 'actions/medical_services/sheet_doctor'
require_relative 'actions/medical_services/cheap_doctor'
require_relative 'actions/premium_services/un_secreto'
require_relative 'actions/scrum_services/scrum_social'
require_relative 'actions/image_manipulator/chimuelo_advance'
require_relative 'actions/image_manipulator/remove_bg'
require_relative 'actions/user_interactions'
require_relative 'actions/games/nunca_nunca'
require_relative 'actions/games/secret_friend'
require_relative 'actions/games/magic_dice'
require_relative 'actions/out_of_context_internal_jokes'
require_relative 'actions/chinese_horoscope'
require_relative 'actions/macaulay_culkin'
# require_relative 'actions/celery'
# require_relative 'actions/employees'
# require_relative 'actions/techdebt'
# require_relative 'actions/organization'
# require_relative 'actions/idocy/askme'

# Will does not refer to any particular desire,
# but rather to the mechanism for choosing from among one's directives.
class Directive
  extend AdminSlack
  extend ImageSlack

  def self.check(data)
    text = data.text
    user = data.user
    channel = data.channel

    unless channel.nil?
      if ENV['SLACK_RESTRICTED_CHANNELS'].include? channel
        SystemEmoji.exec(data)
        AutoEmoji.exec(data)
      end
    end

    case text
    when /^\\/
      Directive.system_list(text, data) if root_list_include?(user)
    when /(un secreto a|un secreto|secreto a|secreto)/
      Thread.new { PremiumSecret.exec(data) }
    when /^(enerbot|#{ENV['SLACK_BOT_NAME']})/i
      Thread.new do
        Directive.command_list(text, data)
      end
    when /^enerscrum/i
      Thread.new { Directive.scrum_list(text, data) }
    when /^enerdoc/i
      Thread.new { Directive.doctor_list(text, data) }
    when /<@(.*?)>.*(\+\+|--|balance)/
      Thread.new { BankTeller.exec(data) }
    when /^[-_](.*)/
      Thread.new { Directive.ref_list(text, data) }
    when /^(zenbot)/i
      Thread.new do
        event_look_set('Zenbot', 'https://i.imgur.com/Fswhv2H.png')
        Directive.zen_list(text, data)
        event_look_revert
      end
    when /(You have been removed from)/
      SystemReject.exec(data)
    end
  end

  def self.command_list(text, data)
    func = { /(ayuda|help)/ => GeneralHelp,
             /(sing\s|canta)/ => SingSong,
             /((sismo|sismos)$|(sismo|sismos) \d)/ => ChileEarthQuakes,
             /(baila)/ => DiscoDance,
             /\sroll\s\d/ => MagicDice,
             /(clima|clima de)/ => WeatherReport,
             /analiza (http|<http)/ => SearchWebSecurity,
             /haarp/ => SearchEarthquakes,
             /recomienda una canci[oó]n/ => RecommendSong,
             /give me a cybersecurity excuse/i => ResponseSecurity,
             /(hor[oó]scopo chino)/i => SearchChineseHoroscope,
             /hor[oó]scopo/i => SearchHoroscope,
             /dame una excusa/ => RetrieveExcuse,
             /dame un consejo/ => RetrieveAdvice,
             /(dame|dale) feedback/ => RetrieveFeedback,
             /dame un mas/ => RetrieveMore,
             /dame un beneficio/ => RetrieveBenefit,
             /(frase) (para el bronce)/ => RetrieveBronce,
             /(frase) (profunda)/ => ResponseMotivation,
             /chiste corto/ => ResponseJok,
             /cuenta un chiste/ => ResponseJoke,
             /dame (un chiste de meruane|un buen chiste)/ => RetrieveMeruane,
             /(dame|tira|tirate) (un|una) (vers[ií]culo|cita b[ií]blica|biblia)/ => RetrieveBible,
             /(una|tirate una) paya/ => RetrievePaya,
             /santo sepulcro a/ => Chimuelo,
             /frase bronce/ => RetrieveBronce,
             /pr[oó]ximo feriado /i => TimeUntilHoliday,
             /(cu[aá]nto) .* (18)/i => TimeUntilSeptember,
             /(cu[aá]ndo).*(pagan)/i => TimeUntilGardel,
             /(softlayer|plataforma)/i => TimeUntilCaos,
             /(pregunta).*(reflex|meditar|pensar)/ => ResponseQuestion,
             /presentate con estilo/ => ResponsePresentation,
             /un saludo navideño/ => MacaulayCulkin,
             /\sagente/ => ResponseAgent,
             /\s(busca|videos de)\s/ => YoutubeSearch,
             /una polemica/ => RetrievePolemica,
             /dame un refr[aá]n/ => RetrieveRefran,
             /compatibilidad/ => SearchCompability,
             /(\s@\s|asado)/ => SystemAutoBan,
             /c[oó]mo se dice/ => TranslateText,
             /energon info/ => CommLinks,
             /(n[uú]mer).*?(kino)/ => KinoNumbers,
             /(ganador kino|resultad(o|os) kino)/ => KinoWinner,
             /santo sepulcro con estilo a/ => ChimueloAdvance,
             /(elimina|remueve).*fondo de/ => ImageRemoveBG,
             /(elimina) a <@(.*)>/ => ImageRemoveBG,
             /dame un commit/ => ResponseCommit,
             /qu[eé] caballero .* soy/ => SearchKnight,
             /amigo secreto/ => SecretFriend,
             # /(debt|recuerda)\s<@/ => DebtAdd,
             # /(deuda|deudas)\s<@/ => DebtGet,
             # /(inducci[oó]n)/ => ResponseIntro,
             # /enerbot qu[eé]/ => AskMe,
             # /enerbot aprende/ => AskIt,
             /servicios cuarentena/ => QtService,
             /(yo (nunca|nunca nunca)$|(yo nunca) (random|niños|adolescente|adulto|joven|sfw|inc[oó]mod[ao]|nsfw))/ => RetrieveNeverNever,
             /(centro[s] m[eé]dico[s]|hospitales|clínicas|status (clínicas|hospitales)|internados)/ => HospitalCheck,
             /(hol[ai]$|hello$|love$|dame amor|recomienda|frase de)/ => ResponseHi,
             /.*/ => OCIJokes }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.system_list(text, data)
    func = { /(ayuda|help)$/ => GeneralHelp,
             /(hol[ai]|hello|hi)$/ => SystemHi,
             /history\s/ => SystemHistory,
             /shutdown$/ => SystemKill,
             /(echo|dm)/ => SystemEcho,
             /(getta change|replace|mod[oe]|backup)/ => SystemImage,
             /revive/ => SystemImageBeyond,
             /search/ => SystemUserList,
             /copy/ => SystemCustomImage,
             /react/ => SystemReaction,
             # /add/ => AdminProfile,
             # /grant/ => Market,
             # /(events|status)$/ => SystemStatus,
             # /nsfw/ => SystemNSFW,
             /visto/ => SystemIgnore,
             /(nsfw|nsfw (unlock|lock))$/ => SystemNSFW,
             # /enerstar/ => SystemEnerStar,
             /(secho|sreact)/ => SystemLastEvent }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.scrum_list(text, data)
    func = { /(ayuda|help)/ => GeneralHelp,
             /(hol[ai]|hello|hi)$/ => ScrumHi,
             /(h[aá]blame|sal[uú]dame)$/ => ScrumDM }
    # /(ensayo)$/ => ScrumDaily,
    # /(check)\s<@(.*)>$/ => ScrumCheck,
    # /attach/ => ScrumAttach,
    # /get my daily/ => ScrumRetrieve,
    # /add me/ => ScrumAdd,
    # /daily start/ => ScrumDaily2,
    # /(members|miembros)/ => ScrumMembers,
    # /group info/ => ScrumInfo,
    # /standup a/ => ScrumStandup }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.doctor_list(text, data)
    func = { /(ayuda|help)/ => GeneralHelp,
             # /ati[eé]ndeme/ => DoctorAsk,
             /(dame tips|consejos)/ => DoctorTips,
             /(infectados|corona)/ => DoctorCases,
             /(centro[s] m[eé]dico[s]|hospitales|clínicas|status (clínicas|hospitales)|internados)/ => HospitalCheck,
             /(muertes por corona|muertes)/ => DoctorDeaths,
             /(en UCI|UCI)/i => DoctorUCI }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.ref_list(text, data)
    func = { /(help|ayuda)$/ => ReferenceHelp,
             /(.*)/ => ReferenceMatrix }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.zen_list(text, data)
    func = { /(help|ayuda)$/ => GeneralHelp,
             /game/ => ZenGame,
             /(link|breath|one minute)/ => ZenLink }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end
end
