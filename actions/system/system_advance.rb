require './lib/message_slack'
require 'google/cloud/firestore'

class SystemDocs
  def initialize(doc:, col: 'enerbot_memory')
    @full_path = "#{col}/#{doc}"
    @firestore = Google::Cloud::Firestore.new
  end

  def get_data
    document = @firestore.doc @full_path
    document.get
  end

  def set_data(value, action = 'ban', field = 'list')
    current = get_data[field]

    update = if action == 'delete'
               current.gsub(value, '')
             else
               current += value
             end
    document = @firestore.doc @full_path
    document.set('list' => update)
  end

  def set_song(link, date)
    document = @firestore.doc @full_path
    document.set('link' => link, 'time' => date)
  end
end

module SystemTrivia
  extend MessageSlack

  def self.exec(data)
    today = Time.now.strftime('%Y%m%d')
    db = SystemDocs.new(doc: 'globant')
    info = db.get_data

    check = nil
    check = data.text.match(/(^(pausa|trivia|enerbot.*trivia))/) unless data.text.nil?
    unless check.nil?
      if info['time'] == today
        url = "<#{info['link']}|SongTrivia> :microphone: "
        send_message(url, data)
      else
        send_message(['Aún no definen room....', 'Alguien decidió extender la meet', 'Esperando a que suban el link', 'No me haría expectativas...'].sample, data)
      end
    end
    link = data.text.match(%r{<(https://songtrivia2.*)>})
    if data.user == 'ULSPGBVSM' && !link.nil?
      db.set_song(link[1], today) if info['time'] != today
      # send_message("<#{link[1]}|SongTrivia> :microphone:", data)
    end
  end
end

### ADMIN: \visto (para|delete) (*@user1*)
module SystemBan
  extend MessageSlack

  def self.exec(data)
    db = SystemDocs.new(doc: 'ban_users')
    remove = data.text.match(/(delete)\s<@(.*)>/)
    unless remove.nil?
      db.set_data(remove[2], remove[1])
      send_message("<@#{remove[2]}> perdonado", data)
    end
    check = data.text.match(/para <@(.*)>/)
    unless check.nil?
      db.set_data(check[1])
      send_message("<@#{check[1]}> quedará con vistos permanentes", data)
    end
  end
end

module SystemAutoBan
  extend MessageSlack

  def self.exec(data)
    db = SystemDocs.new(doc: 'ban_users')
    check = data.user.match(/<@(.*)>/)
    unless check.nil?
      db.set_data(check[1])
      add_reaction('angry', data.channel, data.ts)
    end
  end
end
