require './voice'
require './senses/sight'
require './mind/consciousness'
require './will/personality'
require_relative 'get_data'
require_relative 'create_data'

module AskMe
  extend Voice

  def self.exec(data)
    type = ''
    if (match = data.text.match(/(qu[eé]|quien)/i))
      type = match.captures[0]
    end
    col_path = case type
               when /qu[eé]/
                 'ML/pronombres/qu[eé]/'
               end
    value = LearnAnswer.filter_question(data.text)
    pool = LearnAnswer.find_questions(col_path)
    answers = LearnAnswer.check_questions(value, pool)
    text = if answers.empty?
             'Lo sé, pero quiero que tu lo digas primero para ver si estamos alineados.'
           else
             "Encontré un total de #{answers.size} respuestas posibles. Aquí te dejo la primera:\n*#{answers.sample}*"
            end
    normal_talk(text, data, data.ts)
  end
end

module AskIt
  extend Voice
  extend Slack_history
  extend CreateAnswer

  def self.exec(data)
    emoji = %w[notebook].sample
    add_reaction(emoji, data.channel, data.ts)
    user = data.user
    dm = direct_talk(user)

    normal_talk("Hola <@#{user}>, ¿qué me enseñarás hoy?", dm)
    questions = ["Dime la pregunte, idealmente en este formato '(qué|quién|cómo|cuándo) (.*)'", 'Y ahora la respuesta, por favor']
    qa = []
    wait_time = 0.5
    questions.each do |line|
      normal_talk(line, dm)
      begin
        time = wait_time += 0.1
        sleep(time)
        text, full = last_message(1, dm, 'chat')
      end until full =~ /(#{user})/
      wait_time = 0.5
      qa << text
    end
    p qa[0]
    set_collection('ML/pronombres/qu[eé]', qa[0], qa[1])

    normal_talk("Excelente, gracias <@#{data.user}>", dm)
  end
end
