require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require './voice'
require './mind/consciousness'
require 'countries'
require 'json'
require 'net/http'
require 'date'

class CheckSheet
  def initialize
    client_id = Google::Auth::ClientId.from_file './config/sheets.json'
    token_store = Google::Auth::Stores::FileTokenStore.new file: './config/token.yaml'
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY, token_store
    user_id = 'default'
    @credentials = authorizer.get_credentials user_id
    p @credentials
  end

  def get_info(range)
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = 'Google Sheets API Ruby Quickstart'
    service.authorization = @credentials

    spreadsheet_id = '1mLx2L8nMaRZu0Sy4lyFniDewl6jDcgnxB_d0lHG-boc'
    service.get_spreadsheet_values spreadsheet_id, range
  end
end

### DOCTOR: muertes --- ENER-DOC te dará la cifra actualizada de muertes en un pais.
module DoctorCoronaKills
  extend Voice
  extend Persona

  def self.exec(data)
    country = 'chile'
    if (match = data.text.match(/(muertes por corona|muertes|finaos) (.*?)$/i))
      country = match.captures[1]
    end
    c = ISO3166::Country.find_country_by_name(country)

    text = ''
    if c.alpha2.eql?('CL')
      sheet = CheckSheet.new
      result = sheet.get_info("'muertes'!A5:ZZ21")
      text = ":cityscape: *Total number of deaths by city*\n```"
      puts 'No data found.' if result.values.empty?
      result.values.each do |row|
        unless row[0].nil? || row[0].empty?
          diff = 20 - row[0].length
          text += (row[0]).to_s + ' '.ljust(diff) + "= #{row[-1]}\n"
        end
      end
      text += '```'
    else
      api = JSON.parse(Net::HTTP.get(URI("https://api.covid19api.com/total/country/#{c.alpha2}")))
      cases = api.last
      last_update = Date.parse(cases['Date']).strftime('%Y-%m-%d')
      text = "At date #{last_update}, there are #{cases['Deaths']} deaths at #{c.translations['en']}"
    end
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    normal_talk(text, data)
    event_look_revert
  end
end

### DOCTOR: lista de infectados || avance del corona virus --- ENER-DOC te dará la cifra actualizada de casos en un pais.
module DoctorCoronaCases
  extend Voice
  extend Persona

  def self.exec(data)
    country = 'chile'
    if (match = data.text.match(/(infectados|corona) (.*?)$/i))
      country = match.captures[1]
    end
    c = ISO3166::Country.find_country_by_name(country)

    text = ''

    if c.alpha2.eql?('CL')
      sheet = CheckSheet.new
      result = sheet.get_info("'acumulados'!A20:ZZ36")
      text = ":cityscape: *Region* & *Total Cases*\n```"
      puts 'No data found.' if result.values.empty?
      result.values.each do |row|
        unless row[0].nil? || row[0].empty?
          diff = 20 - row[0].length
          text += (row[0]).to_s + ' '.ljust(diff) + "= #{row[-1]}\n"
        end
      end
      text += '```'
    else
      api = JSON.parse(Net::HTTP.get(URI("https://api.covid19api.com/total/country/#{c.alpha2}")))
      cases = api.last
      last_update = Date.parse(cases['Date']).strftime('%Y-%m-%d')
      text = "At date #{last_update}, there are #{cases['Confirmed']} confirmed cases at #{c.translations['en']}"
    end

    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    normal_talk(text, data)
    event_look_revert
  end
end

### DOCTOR: en uci || uci --- ENER-DOC te dará la cifra actualizada de pacientes en UCI.
module DoctorCoronaUCI
  extend Voice
  extend Persona

  def self.exec(data)
    sheet = CheckSheet.new
    result = sheet.get_info("'en uci'!A5:ZZ21")
    text = ":cityscape: *Personas en Unidad de Cuidado Intensivo con monitor y ventilador (UCI)*\n```"
    puts 'No data found.' if result.values.empty?
    result.values.each do |row|
      unless row[0].nil? || row[0].empty?
        diff = 20 - row[0].length
        text += (row[0]).to_s + ' '.ljust(diff) + "= #{row[-1]}\n"
      end
    end
    text += '```'
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    normal_talk(text, data)
    event_look_revert
  end
end
