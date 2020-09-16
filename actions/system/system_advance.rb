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
    document.set('list' => "#{update},")
  end

  def set_song(link, date)
    document = @firestore.doc @full_path
    document.set('link' => link, 'time' => date)
  end
end

### HELP: visto (para|delete) (*@user1*) --- Self defense using 'seen' emojis.
module SystemIgnore
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

module SystemEmoji
  extend MessageSlack

  def self.exec(data)
    db = SystemDocs.new(doc: 'ban_users')
    unless data.user.nil?
      db.get_data['list'].include? data.user
      add_reaction('seen', data.channel, data.ts) if db.get_data['list'].include? data.user
    end
  end
end
