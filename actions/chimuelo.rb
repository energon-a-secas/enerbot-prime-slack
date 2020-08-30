require './lib/message_slack'

### help: santo sepulcro a (*@user1*|*service*) --- Realiza el sepulcro de un miembro de Slack
module Chimuelo
  extend MessageSlack

  def self.exec(data)
    target = data.text
    user = data.user
    to = ''
    if (match = target.match(/santo sepulcro a (.*?)$/i))
      to = match.captures[0]
    end

    to = to.empty? ? "<@#{user}>" : to
    to = "<@#{user}>" if to =~ /(energon|enerbot)/i

    text = <<~HEREDOC
      :chimuelo:
      _«Ave María_
      _Señor Jesús_
      _Lleva a *#{to}* al ataúd_
      _Ave María_
      _Don Cristo_
      _Lleva a *#{to}*_
      _A su lugar_
      _*#{to}*, descansa, ya estás en paz.»_
      :doge:
    HEREDOC
    send_message(text, data)
  end
end
