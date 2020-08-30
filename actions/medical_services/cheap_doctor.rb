require './lib/message_slack'
require './lib/image_slack'

### DOCTOR: dame tips || dame consejos --- ENER-DOC te explicará que hacer para mantenerte sano y a salvo.
module DoctorTips
  extend MessageSlack
  extend ImageSlack

  def self.exec(data)
    add_reaction('helicopter', data.channel, data.ts)
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    actions = ['Lávate las manos durante al menos 20 segundos con agua y jabón.', 'Evita tocarte la cara.', 'Mantén una distancia de 1 a 2 metros de otras personas en la medida de lo posible.'].sample
    supplements = ['Agua de manzanilla nunca falla.', 'La vitamina C no te hará inmune pero te ayudará con los resfríos comunes.', 'Harto liquido, ahí lo dejo.'].sample
    office = ['Evita las reuniones en salas no diseñadas para sostener un ambiente agradable para más de 3 personas.', 'No compartas tu mate', 'Eviten utilizar los mismos utencilios de la cocina.', 'Trabaja remoto si puedes.', 'No vengas si ya estas resfriado. Agradecemos tu compromiso, pero no apreciamos tus mocos.'].sample
    protips = ['La mascarilla no te da inmunidad, solo ayuda a que tú no contagies a otros.', 'Evita el metro en horario punta.'].sample

    text = ":potable_water: *Acciones:* #{actions}\n:pill: *Suplementos:* #{supplements}\n:office: *Oficina:* #{office}\n:star: *Pro TIPs:* #{protips}"
    send_message(text, data)
    event_look_revert
  end
end

# ### DOCTOR: atiendeme --- ENER-DOC te atenderá por interno.
# module DoctorAsk
#   extend MessageSlack
#   extend Conversation
#   extend ImageSlack
#
#   def self.exec(data)
#     event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
#     add_reaction('medical_symbol', data.channel, data.ts)
#     hello = ['Cuéntame, ¿qué te sucede?.', 'Espero que estes usando una VPN para hablarme, ¿cómo te has sentido ultimamente?'].sample
#
#     channel = get_user_id(data.user)
#     send_message(hello, channel)
#     sleep(1)
#     text, valid = dialog(data.user, '(resfriad|enferm|preocupad|asustad|dolor|duele)', 5, channel, 'chat')
#     if valid == true
#       send_message('Te diagnostico con seguir viviendo', channel)
#     else
#       send_message('Desearía seguir prestandote atención, pero tengo mejores cosas que hacer.', channel)
#     end
#     event_look_revert
#   end
# end
