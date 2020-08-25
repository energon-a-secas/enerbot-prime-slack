require 'google/cloud/firestore'
require './voice'

# Modules for Firestore operations
module FireProfile
  def self.create_profile(id, name, email, job)
    firestore = Google::Cloud::Firestore.new

    employee = firestore.doc("enerployees/#{id}")
    employee.set(
      name: name,
      id: id,
      email: email,
      job: job
    )
  end

  def self.get_profile(id)
    extend Voice

    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "enerployees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      "*Name:* #{info[:name]}\n*Email:* #{info[:email]}\n*Job:* #{info[:job]}"
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end

  def self.get_profile_data(id, text)
    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "enerployees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      response = case text
                 when /name/
                   "*Name:* #{info[:name]}\n"
                 when /email/
                   "*Email:* #{info[:email]}\n"
                 when /hacker/
                   "*Job:* #{info[:job]}\n"
                 end
      response
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end

  def self.update_profile_data(id, text)
    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "enerployees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      response = case text
                 when /name/
                   "*Name:* #{info[:name]}\n"
                 when /email/
                   "*Email:* #{info[:email]}\n"
                 when /job/
                   "*Job:* #{info[:job]}\n"
                 end
      response
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end
end

### ADMIN: add *< @user >* --- Crea un perfil oficial en ENERGON.
module AdminProfile
  extend Voice

  def self.exec(data)
    client = configure_client('web')
    user_id = ''
    user_name = ''
    user_job = 'Minion'
    if (match = data.text.match(/\\add\s<@(.*)>\s(.*)$/i))
      user_id = match.captures[0]
      user_job = match.captures[1]

      c = client.users_info user: user_id
      user_name = c.user.real_name
    end

    id = user_id
    name = user_name
    email = Faker::Internet.email
    job = user_job
    FireProfile.create_profile(id, name, email, job)
    normal_talk(FireProfile.get_profile(id), data)
  end
end

### HELP: mi cargo || cargo de *< @user >* --- Revisa la información de empleado oficial de ENERGON.
module AdminGet
  extend Voice

  def self.exec(data)
    user_id = case data.text
              when /(cargo de)\s<@(.*)>/
                user_id = ''
                if (match = data.text.match(/<@(.*?)>$/i))
                  user_id = match.captures[0]
                end
                user_id
              when /(mi cargo)/
                data.user
              end
    normal_talk(FireProfile.get_profile(user_id), data)
  end
end

### ADMIN: mi cargo || cargo de *< @user >* *< name | email | job | hacker | pet >* --- Revisa un atributo especifico de un empleado en ENERGON.
module AdminDetails
  extend Voice

  def self.exec(data)
    text = data.text
    user_id, user_data = case text
                         when /(check|finger)\s<@(.*)>\s(\w.*)/
                           user_id = ''
                           user_data = ''
                           if (match = text.match(/<@(.*?)>\s(\w.*)/i))
                             user_id = match.captures[0]
                             user_data = match.captures[1]
                           end
                           [user_id, user_data]
                         else
                           if (match = data.text.match(/<@(.*?)>\s(\w.*)/i))
                             user_data = match.captures[1]
                             [data.user, user_data]
                           end
                         end

    info = FireProfile.get_profile_data(user_id, user_data)
    normal_talk(info, data)
  end
end
