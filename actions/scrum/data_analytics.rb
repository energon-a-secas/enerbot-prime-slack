require 'google/cloud/firestore'

module ScrumGroup
  def self.create_group(group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    member = firestore.doc("scrum/workspace/energonhq/#{group}")
    member.set(
      active: true
    )
  end

  def self.update_group(channel, group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    member = firestore.doc("scrum/workspace/energonhq/#{group}")
    member.update(
      channel: channel
    )
  end

  def self.create_user(id, name, group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    member = firestore.doc("scrum/workspace/energonhq/#{group}/members/#{id}")
    member.set(
      active: true,
      name: name,
      group: group
    )
  end

  def self.save_daily(id, responses, group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    daily = firestore.doc("scrum/workspace/energonhq/#{group}/members/#{id}/daily/#{Time.now.strftime('%d-%m-%y')}")
    daily.set(
      responses: responses
    )
  end

  def self.get_group_info(group = 'evasquad', workspace = 'energonhq')
    firestore = Google::Cloud::Firestore.new

    doc_group = firestore.doc "scrum/workspace/#{workspace}/#{group}"
    check = doc_group.get

    time = '10:00:00'
    active = false
    channel = 'hq-daily'

    if check.exists?
      time = check.data[:time]
      active = check.data[:active]
      channel = check.data[:channel]
    end

    [time, active, channel]
  end

  def self.get_members(group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    member_list = firestore.col "scrum/workspace/energonhq/#{group}/members"
    query = member_list.where 'group', '=', group

    list = "Mis muchachos del *EVASQUAD*:\n"
    query.get do |member|
      list += "\n •  #{member.data[:name]} "
    end
    list
  end

  def self.get_daily(id, group = 'evasquad')
    firestore = Google::Cloud::Firestore.new

    user = firestore.doc("scrum/workspace/energonhq/#{group}/members/#{id}")
    presence = user.get
    if presence.exists?
      daily = firestore.doc("scrum/workspace/energonhq/#{group}/members/#{id}/daily/#{Time.now.strftime('%d-%m-%y')}")
      information = daily.get
      if information.exists?
        [information.data[:responses], 'ok']
      else
        quote = ['Máquina, ¿todo bien?', 'Prueba con `enerscrum daily start`.', 'Conversemos con un :coffee: de ahí.'].sample
        [[], "Daily del #{Time.now.strftime('%d-%m-%y')}, no encontrada. #{quote}"]
      end
    else

      quote = ['parece que no te incluyeron en el team AGILE :face_with_hand_over_mouth:', 'tenemos que conversar en mi oficina.', 'no esta siendo AGILE! ¡Rápido, alguien asignele un ticket!']
      [[], quote]
    end
  end
end
