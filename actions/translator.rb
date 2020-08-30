require './lib/message_slack'
require 'json'
require 'net/http'
require 'uri'
require 'cgi'
require 'guru_guru'

### HELP: como se dice <text> en <ingles|japones|portugues|frances|guru-guru> --- Traducción y otras hierbas.
module TranslateText
  extend MessageSlack
  def self.exec(data)
    text = data.text
    languages = { 'ingles' => 'en',
                  'español' => 'es',
                  'frances' => 'fr',
                  'portugues' => 'pt',
                  'ruso' => 'ru',
                  'aleman' => 'de',
                  'chino' => 'zh',
                  'japones' => 'ja',
                  'italiano' => 'it',
                  'argentino' => 'es',
                  'chileno' => 'es',
                  'brasileño' => 'pt' }

    flags = { 'ingles' => ':uk:',
              'español' => ':es:',
              'frances' => ':fr:',
              'portugues' => ':flag-pt:',
              'ruso' => ':ru:',
              'aleman' => ':de:',
              'chino' => ':flag-cn:',
              'japones' => ':jp:',
              'italiano' => ':it:',
              'argentino' => ':ar:',
              'chileno' => ':flag-cl:',
              'brasileño' => ':flag-br:' }

    to_translate = ''
    to_language = ''
    if (match = text.match(/c[oó]mo se dice (.*) en (.*?)$/i))
      to_translate, to_language = match.captures
    end
    language_fix = to_language.gsub('á', 'a').gsub('é', 'e')
    result = if %w[guru-guru guru_guru guruguru].include? to_language
               "#{to_translate.to_guru_guru} :bird: :shell:"
             elsif languages.key?(language_fix) && !to_translate.to_s.empty?
               url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=es&tl='
               url += languages[language_fix] + '&dt=t&q=' + CGI.escape(to_translate)
               result = Net::HTTP.get(URI(url))

               translated = JSON.parse(result)[0][0][0]
               "#{translated} #{flags[language_fix]}"
             else
               'https://cdn.memegenerator.es/imagenes/memes/full/22/4/22044287.jpg'
             end
    send_message(result, data)
end
end
