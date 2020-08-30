require 'date'
require 'json'
require 'net/http'
require './lib/message_slack'

module SearchWebSecurity
  extend MessageSlack

  def self.exec(data)
    url = data.text.split[2].split('|')[1].chomp('>')
    uri = "https://sitecheck.sucuri.net/api/v2/?scan=#{url}"

    analyse = JSON.parse(Net::HTTP.get(URI(uri)))
    recommendations = analyse['RECOMMENDATIONS']['LIST']
    string_analysed = 'NINGUN WARNING, FELICITACIONES :clap2:'

    if analyse['RECOMMENDATIONS'].key?('LIST')
      string_analysed = "WARNINGS \n "
      recommendations.each do |x|
        string_analysed += ":warning: #{x} \n"
      end
      string_analysed += "\nMAS INFORMACION EN: https://sitecheck.sucuri.net/results/#{url}\n"
    end
    send_message(string_analysed, data)
  end
end

### help: haarp --- Entrega información sobre temblores/terremotos recientes en Chile.
module SearchEarthquakes
  extend MessageSlack

  def self.exec(data)
    api = JSON.parse(Net::HTTP.get(URI('https://chilealerta.com/api/query/?user=demo&select=ultimos_sismos&country=chile')))
    chile = api['ultimos_sismos_chile'][0]
    text = ":clock1: *Hora:* #{chile['chilean_time']}\n:earth_americas: *Ubicación:* #{chile['reference']}\n:triggered_energon: *Magnitud:* #{chile['magnitude']}"
    send_message(text, data)
  end
end

# # Module for search elements in Have I Been Pwned
# module SearchHaveIBeen
#   extend Voice
#   def self.exec(data)
#     if (match = data.text.match(/pwned email ((.*)\|)?(.*?)(\>)?$/i))
#       email = match.captures[2]
#     end
#
#     message = "No info for #{email}"
#     if email
#       http = Net::HTTP.new('haveibeenpwned.com', 443)
#       http.use_ssl = true
#       req = Net::HTTP::Get.new("/api/v2/breachedaccount/#{email}", 'User-Agent' => 'enerbot-hibp-email')
#       res = http.request(req)
#
#       if res.code == '200'
#         breaches = JSON.parse(res.body)
#         plural = breaches.length > 1 ? 's' : ''
#         message = "El email \"#{email}\" ha sido listado en *#{breaches.length}* brecha#{plural} :\n"
#         breaches.each do |breach|
#           domain = breach['Domain'].empty? ? 'Lista de SPAM' : breach['Domain']
#           message += "\t:rotating_light: #{breach['Title']} (#{domain}) #{breach['BreachDate']}\n"
#         end
#         message += "\nTe recomiendo que cambies tus contraseñas (sugiero `enerbot password sec`)"
#       elsif res.code == '429'
#         message = '_Rate limit exceeded_ :wait_energon:'
#       end
#
#     else
#       message = 'Debes especificar un email'
#     end
#     send_message(message, data)
#     end
# end
