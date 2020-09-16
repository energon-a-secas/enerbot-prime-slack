require './lib/message_slack'

### ENERBOT: roll (*number*) --- Enerbot demuestra que un dado de 37 caras es viable.
module MagicDice
  extend MessageSlack
  def self.exec(data)
    text = data.text
    dice = '4'
    if (match = text.match(/roll (\d+) (\d+)/i))
      dice = match.captures[0].to_i

      number = match.captures[1].to_i
      face = if number.even?
               results = ''
               number
             else
               results = "You number #{number} has been increased by 1 :gandalf:\n"
               number.next
             end
    end

    total = 0
    min = ''
    max = ''

    message = if dice > 20
                ":game_die: #{dice} es un cantidad absurda, prueba con otra"
              else
                (1..dice).each do |i|
                  result = (1..face).to_a
                  min = result.min
                  max = result.max
                  num = result.shuffle![3]
                  total += num
                  results += "\n*:game_die: Dado #{i}:* #{num}"
                end
                "*Results:* #{results}\nSuming a total of *#{total}* :gandalf_parrot: \n*Minimum rolled number:* #{min}\n*Maximum rolled number:* #{max} "
    end
    send_message(message, data)
  end
end
