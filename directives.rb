require_relative 'lib/admin_slack'
require_relative 'actions/sing'
require_relative 'actions/dance'
require_relative 'actions/responses'
require_relative 'actions/retrieve'
require_relative 'actions/apis/horoscope'
require_relative 'actions/apis/security'
require_relative 'actions/chimuelo'
require_relative 'actions/help'
require_relative 'actions/important_dates'
require_relative 'actions/cultural_references'
require_relative 'actions/youtube'
require_relative 'actions/zenbot/zenbot'
require_relative 'actions/translator'
require_relative 'actions/quarantine'
require_relative 'actions/medical_services/hospital_apis'
require_relative 'actions/medical_services/sheet_doctor'
require_relative 'actions/medical_services/cheap_doctor'
require_relative 'actions/system/system_actions'
require_relative 'actions/system/system_advance'
require_relative 'actions/system/system_image'
require_relative 'actions/energon_coins/bank_teller'
require_relative 'actions/scrum_services/scrum_social'
# require_relative 'actions/celery'
# require_relative 'actions/employees'
# require_relative 'actions/techdebt'
# require_relative 'actions/organization'
# require_relative 'actions/idocy/askme'

# Will does not refer to any particular desire,
# but rather to the mechanism for choosing from among one's directives.
class Directive
  extend AdminSlack

  def self.check(data)
    text = data.text
    user = data.user
    # SystemSD.exec(data)

    case text
    when /^\\/
      Directive.system_list(text, data) if root_list_include?(user)
    when /^enerbot/i
      Thread.new { Directive.command_list(text, data) }
    when /^enerscrum/i
      Thread.new { Directive.scrum_list(text, data) }
    when /^enerdoc/i
      Thread.new { Directive.doctor_list(text, data) }
    when /<@(.*?)>.*(\+\+|--|balance)/
      Thread.new { BankTeller.exec(data) }
    when /^[-_](.*)/
      Thread.new { Directive.ref_list(text, data) }
    when /^(zenbot)/
      Thread.new { Directive.zen_list(text, data) }
    end
  end

  def self.command_list(text, data)
    func = { /(ayuda|help)/ => GeneralHelp,
             /(sing|canta)/ => SingSong,
             /(baila)/ => DiscoDance,
             /haarp/ => SearchEarthquakes,
             /recomienda una canci[oó]n/ => RecommendSong,
             /(hol[ai]$|hello$|love$|dame amor|recomienda)/ => ResponseHi,
             /give me a cybersecurity excuse/i => ResponseSecurity,
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
             /pr[oó]ximo feriado /i => TimeToHoliday,
             /(cu[aá]nto) .* (18)/i => TimeToSeptember,
             /(cu[aá]ndo) .* (pagan)/i => TimeToGardel,
             /(softlayer|plataforma)/i => TimeToCaos,
             /(pregunta).*(reflex|meditar|pensar)/ => ResponseQuestion,
             /presentate con estilo/ => ResponsePresentation,
             /\sagente/ => ResponseAgent,
             /enerbot busca/ => YoutubeSearch,
             /una polemica/ => RetrievePolemica,
             /dame un refr[aá]n/ => RetrieveRefran,
             /compatibilidad/ => SearchCompability,
             /(\s@\s|asado)/ => SystemAutoBan,
             /c[oó]mo se dice/ => TranslateText,
             # /(oyster|celery)/ => CeleryMan,
             # /(create|add me)/i => GenerateProfile,
             # /(check|finger)\s(<@(.*)>|me)$/ => GetProfile,
             # /(check|finger)\s(<@(.*)>|me)\s(\w.*)/ => GetDetail,
             # /(debt|recuerda)\s<@/ => DebtAdd,
             # /(deuda|deudas)\s<@/ => DebtGet,
             # /(inducci[oó]n)/ => ResponseIntro,
             # /(mi cargo|cargo de <@(.*)>)$/ => AdminGet,
             # /(mi cargo|cargo de <@(.*)>)\s(\w.*)/ => AdminDetails,
             # /enerbot qu[eé]/ => AskMe,
             # /enerbot aprende/ => AskIt,
             /servicios cuarentena/ => QtService,
             # /[Pp](ichanga|iscola)/ => ResponseZorron,
             /(centro[s] m[eé]dico[s]|hospitales|clínicas|status (clínicas|hospitales)|internados)/ => HospitalCheck }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.system_list(text, data)
    func = { /(ayuda|help)$/ => GeneralHelp,
             /(hol[ai]|hello|hi)$/ => SystemHi,
             /history\s/ => SystemHistory,
             /shutdown$/ => SystemKill,
             /(echo)/ => SystemEcho,
             /(getta change|replace|mod[oe]|copy|backup)/ => SystemImage,
             /revive/ => SystemImageBeyond,
             /search/ => SystemUserList,
             /copy/ => SystemCustomImage,
             /react/ => SystemReaction,
             # /add/ => AdminProfile,
             # /grant/ => Market,
             # /(events|status)$/ => SystemStatus,
             # /nsfw/ => SystemNSFW,
             /visto/ => SystemSD }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.scrum_list(text, data)
    func = { /(ayuda|help)/ => GeneralHelp,
             /(hol[ai]|hello|hi)$/ => ScrumHi,
             /(h[aá]blame|sal[uú]dame)$/ => ScrumDM }
             #/(ensayo)$/ => ScrumDaily,
             #/(check)\s<@(.*)>$/ => ScrumCheck,
             #/attach/ => ScrumAttach,
             #/get my daily/ => ScrumRetrieve,
             #/add me/ => ScrumAdd,
             #/daily start/ => ScrumDaily2,
             #/(members|miembros)/ => ScrumMembers,
             #/group info/ => ScrumInfo,
             #/standup a/ => ScrumStandup }
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
             /game/ => ZenGame }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end
end
