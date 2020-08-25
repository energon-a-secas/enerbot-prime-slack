require './voice'
require 'google/cloud/firestore'

### help: *< debt | recuerda >* *< @user >* *< tech or moral debts >* --- Crea una deuda técnica o moral para el usuario entregado.
module DebtAdd
  extend Voice
  def self.exec(data)
    firestore = Google::Cloud::Firestore.new

    text = data.text
    text.slice!('enerbot debt ')

    employee = firestore.doc("debts/#{(0...14).map { rand(65..90).chr }.join}")
    employee.set(
      debt: text
    )

    normal_talk(['Tamos', 'Dudo que se me olvide... ¿Qué estabamos hablando?', 'Peyo, recuerda pagar la cuenta de la db'].sample, data)
  end
end

### help: *< deuda | deudas >* *< @user >* --- Revisa deudas de usuario especificado.
module DebtGet
  extend Voice
  def self.exec(data)
    human = ''
    if (match = data.text.match(/<@(.*?)>$/i))
      human = match.captures[0]
    end
    firestore = Google::Cloud::Firestore.new
    quote_col = firestore.col('debts')
    line = "Listado de deudas de <@#{human}>:\n"
    quotes = ''
    quote_col.get do |entry|
      if entry[:debt] =~ /^<@#{human}>/
        quotes += "- #{entry[:debt].gsub("<@#{human}> ", '')}\n"
                            end
    end
    text = if quotes.empty?
             ["<@#{human}> no debe nada", "<@#{human}> no te preguntes que puede hacer :energon_enterprise: por ti, pregúntate que puedes hacer tú por :energon_enterprise:"].sample
           else
             line + quotes
            end
    normal_talk(text, data)
  end
end
