require './lib/message_slack'

### ENERBOT: energon info --- Regresará links relevantes.
module CommLinks
  extend MessageSlack
  def self.exec(data)
    text = [
      {
        "text": '',
        "color": '#FFFFFF',
        "fallback": 'Relevant information',
        "actions": [
          {
            "type": 'button',
            "text": 'Enerbot',
            # "style": 'danger',
            "url": 'https://github.com/energon-a-secas/enerbot-prime-slack'
          },
          {
            "type": 'button',
            "text": 'Energon Cloud',
            #  "style": 'danger',
            "url": 'https://energon.cloud'
          }
        ]
      }
    ]
    send_attachment(text, data)
  end
end
