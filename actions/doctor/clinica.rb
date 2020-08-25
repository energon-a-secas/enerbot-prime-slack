require 'net/http'
require 'json'

### ENERDOC: centros medicos || uso de clinicas --- ENER-DOC te permitirá saber a que clinica no ir.
module ClinicCheck
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('TELE-ENER-DOC', 'https://i.imgur.com/80BYGyJ.png')

    url = 'https://api.jsonbin.io/b/5e6ff3d80f03274866467d4a/3'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    used_centers = JSON.parse(response)

    patients = []

    used_centers.each do |v|
      if v['Región'] == 'Metropolitana'
        patients << v['Centro de salud'].gsub('í', 'i').gsub('tr', 'Tr')
      end
    end

    health_centers = patients.uniq.sort
    text = ''
    health_centers.each do |c|
      result = patients.map(&:downcase).select { |element| element == c.downcase }
      text += "*#{c.gsub(/lin/, 'lín')}*: #{result.count}\n"
    end

    text += "\n\n _Resultados basados en una API de por ahí, use como referencia para evitar Centros atestados. Con amor por :energon_enterprise:_"

    att = [{
      "pretext": ':hospital: Cantidad de internados en centros médicos Chile (Santiago):',
      "color": '#e93d94',
      "text": text
    }]
    attachment_talk(att, data)
    event_look_revert
  end
end
