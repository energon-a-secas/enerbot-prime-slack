require './lib/message_slack'

### ENERBOT: un saludo navideño --- Enerbot te dará un saludo digno de navidad.
module MacaulayCulkin
  extend MessageSlack

  def self.exec(data)
    text = <<~HEREDOC
      «Ya se que eres tu <@#{data.user}>, te huelo desde que entras al ascensor. ¿Estuviste aqui anoche también no?.
      Estuviste aquí y besuqueandote con mi hermano. Te besuqueas con todo el mundo, con Rafie, con Al con Leo, con ese cojo de 32, con Gil, con Bernardo, con Cliff. Puedo seguir toda la noche amorcito....
      Esta bien, te creo, PERO MI METRALLETA NO.
      Ahora de rodillas y dime que me amas.
      Tal vez sea un demente, pero te creo. Por eso voy a dejarte ir.
      Y para antes de que cuente 3 quiero que quites tu horrenda, coqueta, mentirosa y traicionera cara de mi vista.
      UNO...
      DOS...
      (._.)
      <,╤╦╤─ ҉ - - - -
      ¡TRES!
      *Feliz navidad inmundo animal*
      (._.)
      <,╤╦╤─ ҉ - - - -
      ... y feliz año nuevo.»
    HEREDOC
    send_message(text, data)
  end
end
