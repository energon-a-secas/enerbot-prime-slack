require_relative 'sheet_reader'
require './lib/message_slack'
require './lib/image_slack'
require 'fileutils'
require 'countries'
require 'json'
require 'net/http'
require 'date'

### DOCTOR: muertes --- ENERDOC te dará la cifra actualizada de muertes en un pais.
module DoctorDeaths
  extend MessageSlack
  extend ImageSlack

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
    event_look_set('ENERDOC', 'https://i.imgur.com/LjhmSeI.png')
    send_message(text, data)
    event_look_revert
  end
end

### DOCTOR: lista de infectados || avance del corona virus --- ENERDOC te dará la cifra actualizada de casos en un pais.
module DoctorCases
  extend MessageSlack
  extend ImageSlack

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

    event_look_set('ENERDOC', 'https://i.imgur.com/LjhmSeI.png')
    send_message(text, data)
    event_look_revert
  end
end

### DOCTOR: en uci || uci --- ENERDOC te dará la cifra actualizada de pacientes en UCI.
module DoctorUCI
  extend MessageSlack
  extend ImageSlack

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
    event_look_set('ENERDOC', 'https://i.imgur.com/LjhmSeI.png')
    send_message(text, data)
    event_look_revert
  end
end
