require 'week_of_month'
require 'json'
require 'net/http'
require 'holidays'
require 'countries'
require './lib/message_slack'

### ENERBOT: cuánto para el 18? --- Muestra los días restantes para el 18 de septiembre.
module TimeUntilSeptember
  extend MessageSlack

  def self.exec(data)
    y = Date.today
    year = y.strftime('%Y').to_i
    if ((y.strftime('%-m').to_i == 9) && (y.strftime('%-d').to_i > 18)) ||
       (y.strftime('%-m').to_i > 9)
      year += 1
    end

    x = Date.new(year, 9, 18)

    d = (x - y).to_i

    f = d == 1 ? "Falta #{d} día" : "Faltan #{d} días"
    message = if d.zero?
                ':flag-cl: ¡Hoy es 18! ¡A emborracharte!.'
              else
                ":flag-cl: #{f} pa'l 18 de septiembre."
              end
    send_message(message, data)
  end
end

### ENERBOT: cuándo pagan? --- Muestra los días restantes para fin de mes.
module TimeUntilGardel
  extend MessageSlack

  def self.exec(data)
    current_date = Date.parse(Date.today.to_s)
    payment_current_month = Date.parse(current_date.beginning_of_month.upto(current_date.next_month).find(&:working_day?).to_s)
    payment_next_month = Date.parse(current_date.next_month.beginning_of_month.upto(current_date.next_month).find(&:working_day?).to_s)
    d = payment_next_month.mjd - current_date.mjd
    dt = current_date.mjd - payment_current_month.mjd
    message = ''
    if current_date == payment_current_month
      message = '¡Hoy pagan!'
    else
      if dt < 2
        message = "Pagaron hace #{dt} día(s). ¿No te llegó el depósito? Uf...\n"
        message += d == 1 ? "Falta #{d} día" : "Faltan #{d} días"
        message += ' para el siguiente pago.'
      elsif d > 0
        message = d == 1 ? "Falta #{d} día" : "Faltan #{d} días"
        message += ' para que paguen.'
      end
    end
    send_message(message, data)
  end
end

### ENERBOT: próximo feriado (*country*) --- Muestra el próximo feriado del país especificado.
module TimeUntilHoliday
  extend MessageSlack

  def self.exec(data)
    country = 'chile'

    if (match = data.text.match(/pr[óo]ximo feriado (.*?)$/i))
      country = match.captures[0]
    end

    c = ISO3166::Country.find_country_by_name(country)

    holiday = begin
                Holidays.next_holidays(1, [c.alpha2.downcase, :observed])
              rescue StandardError
                nil
              end

    if holiday.nil?
      message = "No puedo obtener feriados para *#{country}*"
    else
      countdown = (holiday[0][:date] - Date.today).to_i
      if countdown.zero?
        message = "Hoy es feriado en :flag-#{c.alpha2.downcase}:, se celebra *\"#{holiday[0][:name]}\"* "
      elsif countdown > 0
        plural = countdown > 1 ? 's' : ''
        message = "Próximo feriado en :flag-#{c.alpha2.downcase}: es en #{countdown} día#{plural} "
        message += "(#{holiday[0][:date].strftime('%Y-%m-%d')}), se celebra *\"#{holiday[0][:name]}\"* "
      else
        message = "No hay feriados para :flag-#{c.alpha2.downcase}: :thinking: :scream:"
      end
    end

    send_message(message, data)
  end
end

### ENERBOT: estado (plataforma|softlayer) --- Estimación aproximada del estado de IBM Cloud
module TimeUntilCaos
  extend MessageSlack

  def self.exec(data)
    per = (1..100).to_a.shuffle![0]

    icon = case per
           when 1..10
             ':rainbow:'
           when 11..20
             ':cloud:'
           when 21..30
             ':partly_sunny:'
           when 31..40
             ':mostly_sunny:'
           when 41..49
             ':partly_sunny_rain:'
           when 50
             ':partly_sunny_rain:'
           when 51..70
             ':full_moon_with_face:'
           when 71..80
             ':rain_cloud:'
           when 81..99
             ':thunder_cloud_and_rain:'
           when 100
             ':newalert:'
           end
    message = case data.text
              when /(probabilidad|pronostico|turno|call|incidentes)/
                "Probabilidad de incidentes para las próximas horas: #{per}% #{icon}"
              else
                "Sin incidentes desde hace #{(Date.parse('4/8/2019')..Date.today).count} días."
              end

    send_message(message, data)
  end
end
