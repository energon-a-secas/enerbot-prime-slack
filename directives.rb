require_relative 'mind/mood'
require_relative 'mind/judgment'
require_relative 'actions/idle'
require_relative 'actions/sing'
require_relative 'actions/dance'
require_relative 'actions/system'
require_relative 'actions/responses'
require_relative 'actions/retrieve'
require_relative 'actions/search'
require_relative 'actions/celery'
require_relative 'actions/chimuelo'
require_relative 'actions/help'
require_relative 'actions/enercoins'
require_relative 'actions/date'
require_relative 'actions/employees'
require_relative 'actions/techdebt'
require_relative 'actions/scrum/daily'
require_relative 'actions/scrum/checks'
require_relative 'actions/scrum/daily_remastered'
require_relative 'actions/organization'
require_relative 'actions/references'
require_relative 'actions/youtube'
require_relative 'actions/idocy/askme'
require_relative 'actions/doctor/consult'
require_relative 'actions/doctor/corona'
require_relative 'actions/doctor/clinica'

# Will does not refer to any particular desire,
# but rather to the mechanism for choosing from among one's directives.
class Directive
  include Mood
  extend Security

  def self.check(data)
    text = data.text
    user = data.user

    case text
    when /^\\/
      Directive.system_list(text, data) if privileges_check(user)
    when /^enerbot/i
      Thread.new { Directive.command_list(text, data) }
    when /^enerscrum/i
      Thread.new { Directive.scrum_list(text, data) }
    when /^enerdoc/i
      Thread.new { Directive.doctor_list(text, data) }
    when /<@(.*?)>.*(\+\+|--|balance)/
      Thread.new { Enercoins.exec(data) }
    when /^[-_](.*)/
      Thread.new { Directive.ref_list(text, data) }
    end
  end

  def self.command_list(text, data)
    func = { /(ayuda|help)/ => SystemHelp,
             /(sing|canta)/ => SingSong,
             /(baila)/ => DiscoDance,
             /haarp/ => SearchEarthquakes,
             /recomienda una canci[oó]n/ => RecommendSong,
             /(hol[ai]$|hello$|love$|dame amor|recomienda)/ => ResponseHi,
             /give me a cybersecurity excuse/i => ResponseSecurity,
             /hor[oó]scopo/i => SearchHoroscope,
             /(oyster|celery)/ => CeleryMan,
             /dame una excusa/ => RetrieveExcuse,
             /dame un consejo/ => RetrieveAdvice,
             /(dame|dale) feedback/ => RetrieveFeedback,
             /dame un mas/ => RetrieveMore,
             /dame un beneficio/ => RetrieveBenefit,
             /dame una frase para el bronce/ => RetrieveBronce,
             /dame (un chiste de meruane|un buen chiste)/ => RetrieveMeruane,
             /(dame|tira|tirate) (un|una) (vers[ií]culo|cita b[ií]blica|biblia)/ => RetrieveBible,
             /(una|tirate una) paya/ => RetrievePaya,
             /santo sepulcro a/ => Chimuelo,
             /frase bronce/ => RetrieveBronce,
             /pr[oó]ximo feriado /i => TimeToHoliday,
             /cu[aá]nto para el 18/i => TimeToSeptember,
             /cu[aá]ndo pagan/i => TimeToGardel,
             /(softlayer|plataforma)/i => TimeToCaos,
             /(create|add me)/i => GenerateProfile,
             /(check|finger)\s(<@(.*)>|me)$/ => GetProfile,
             /(check|finger)\s(<@(.*)>|me)\s(\w.*)/ => GetDetail,
             /presentate con estilo/ => ResponsePresentation,
             /(debt|recuerda)\s<@/ => DebtAdd,
             /(deuda|deudas)\s<@/ => DebtGet,
             /\sagente/ => ResponseAgent,
             /(inducci[oó]n)/ => ResponseIntro,
             /(mi cargo|cargo de <@(.*)>)$/ => AdminGet,
             /(mi cargo|cargo de <@(.*)>)\s(\w.*)/ => AdminDetails,
             /enerbot busca/ => YoutubeSearch,
             /enerbot qu[eé]/ => AskMe,
             /enerbot aprende/ => AskIt,
             /una polemica/ => RetrievePolemica,
             /dame un refr[aá]n/ => RetrieveRefran,
             /servicios cuarentena/ => DoctorServices,
             /(centro[s] m[eé]dico[s]|hospitales|clínicas|status (clínicas|hospitales)|internados)/ => ClinicCheck }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.system_list(text, data)
    func = { /(ayuda|help)$/ => FunctionsHelp,
             /(hol[ai]|hello|hi)$/ => SystemHi,
             /grant/ => Market,
             /(events|status)$/ => SystemStatus,
             /last\s/ => SystemHistory,
             /shutdown$/ => SystemKill,
             /(send)/ => SystemResp,
             /(getta change|replace|mod[oe]|backup)/ => SystemImage,
             /add/ => AdminProfile,
             /revive/ => SystemImageBeyond,
             /search/ => SystemUserList,
             /copy/ => SystemCustomImage,
             /react/ => SystemReaction,
             /nsfw/ => SystemNSFW }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.scrum_list(text, data)
    func = { /(ayuda|help)/ => ScrumHelp,
             /(hol[ai]|hello|hi)$/ => ScrumHi,
             /(h[aá]blame|sal[uú]dame)$/ => ScrumDirect,
             /(ensayo)$/ => ScrumDaily,
             /(check)\s<@(.*)>$/ => ScrumCheck,
             /attach/ => ScrumAttach,
             /get my daily/ => ScrumRetrieve,
             /add me/ => ScrumAdd,
             /daily start/ => ScrumDaily2,
             /(members|miembros)/ => ScrumMembers,
             /group info/ => ScrumInfo,
             /standup a/ => ScrumStandup }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.doctor_list(text, data)
    func = { /(ayuda|help)/ => DoctorHelp,
             /ati[eé]ndeme/ => DoctorAsk,
             /(dame tips|consejos)/ => DoctorTips,
             /(infectados|corona)/ => DoctorCoronaCases,
             /(centro[s] m[eé]dico[s]|hospitales|clínicas|status (clínicas|hospitales)|internados)/ => ClinicCheck,
             /(muertes por corona|muertes|finaos)/ => DoctorCoronaKills,
             /(en UCI|UCI)/i => DoctorCoronaUCI }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end

  def self.ref_list(text, data)
    func = { /(help|ayuda)$/ => ReferenceHelp,
             /(.*)/ => ReferenceMatrix }
    func.keys.find { |key| func[key].exec(data) if key =~ text }
  end
end
