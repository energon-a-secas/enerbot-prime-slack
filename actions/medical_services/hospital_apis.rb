require 'net/http'
require 'json'
require './lib/image_slack'
require './lib/format_slack'

### ENERDOC: centros medicos || hospitales --- ENER-DOC te permitirá saber a que clinica no ir.
module HospitalCheck
  extend MessageSlack
  extend ImageSlack
  extend FormatSlack

  def self.exec(data)
    event_look_set('TELE-ENERDOC', 'https://i.imgur.com/80BYGyJ.png')

    url = 'https://api.jsonbin.io/b/5e6ff3d80f03274866467d4a/3'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    used_centers = JSON.parse(response)

    patients = []

    used_centers.each do |v|
      patients << v['Centro de salud'].gsub('í', 'i').gsub('tr', 'Tr') if v['Región'] == 'Metropolitana'
    end

    health_centers = patients.uniq.sort
    text = ''
    health_centers.each do |c|
      result = patients.map(&:downcase).select { |element| element == c.downcase }
      text += "*#{c.gsub(/lin/, 'lín').gsub('.', '')}*: #{result.count}\n"
    end

    text += "\n\n _Resultados basados en una API de por ahí, use como referencia para evitar Centros atestados. Con amor por :energon_enterprise:_"

    message = attachment_style(text, pretext: ':hospital: Cantidad de internados en centros médicos Chile (Santiago):', color: '#e93d94')
    send_attachment(message, data)
    event_look_revert
  end
end
