require 'google/cloud/firestore'
require './voice'
require 'faker'

# Modules for Firestore operations
module FireProfile
  def self.create_profile(id, name, email, rut, job, job_motto, legacy_project, pet_project, hacker_quote, favorite_kpop_group)
    firestore = Google::Cloud::Firestore.new

    employee = firestore.doc("employees/#{id}")
    employee.set(
      name: name,
      id: id,
      email: email,
      rut: rut,
      job: job,
      job_motto: job_motto,
      legacy_project: legacy_project,
      pet_project: pet_project,
      hacker_quote: hacker_quote,
      favorite_kpop_group: favorite_kpop_group
    )
  end

  def self.get_profile(id)
    extend Voice

    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "employees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      "*Name:* #{info[:name]}\n*RUT:* #{info[:rut]}\n*Email:* #{info[:email]}\n*Job:* #{info[:job]}\n*Job Motto:* #{info[:job_motto]}\n*Legacy project:* #{info[:legacy_project]}\n*Pet project:* #{info[:pet_project]}\n*Hacker quote:* #{info[:hacker_quote]}\n"
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end

  def self.get_profile_data(id, text)
    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "employees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      response = case text
                 when /name/
                   "*Name:* #{info[:name]}\n"
                 when /rut/
                   "*RUT:* #{info[:rut]}\n"
                 when /email/
                   "*Email:* #{info[:email]}\n"
                 when /job/
                   "*Job:* #{info[:job]}\n"
                 when /hacker/
                   "*Hacker quote:* #{info[:hacker_quote]}\n"
                 when /pet/
                   "*Pet project:* #{info[:pet_project]}\n"
                 end
      response
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end

  def self.update_profile_data(id, text)
    firestore = Google::Cloud::Firestore.new
    doc_ref = firestore.doc "employees/#{id}"
    intentions = doc_ref.get
    if intentions.exists?
      info = intentions.data
      response = case text
                 when /name/
                   "*Name:* #{info[:name]}\n"
                 when /rut/
                   "*RUT:* #{info[:rut]}\n"
                 when /email/
                   "*Email:* #{info[:email]}\n"
                 when /job/
                   "*Job:* #{info[:job]}\n"
                 when /hacker/
                   "*Hacker quote:* #{info[:hacker_quote]}\n"
                 when /pet/
                   "*Pet project:* #{info[:pet_project]}\n"
                 end
      response
    else
      ":poli: <@#{id}> is not part of energon"
    end
  end
end

### help: *< create @user | add me >* --- Crea un perfil único tanto para usuario especificado como para ti en ENERGON.
module GenerateProfile
  extend Voice

  def self.exec(data)
    client = configure_client('web')
    user_id, user_name = case data.text
                         when /create\s<@(.*)>/
                           user_id = ''
                           if (match = data.text.match(/<@(.*?)>$/i))
                             user_id = match.captures[0]
                           end
                           c = client.users_info user: user_id
                           [user_id, c.user.real_name]
                         when /add me/
                           c = client.users_info user: data.user
                           [data.user, c.user.real_name]
                          end

    id = user_id
    name = user_name
    email = Faker::Internet.email
    rut = Faker::ChileRut.full_rut
    job = Faker::Company.bs
    job_motto = Faker::Company.buzzword
    legacy_project = Faker::Appliance.equipment
    pet_project = Faker::App.name
    hacker_quote = Faker::Hacker.say_something_smart
    favorite_kpop_group = Faker::Kpop.iii_groups

    FireProfile.create_profile(id, name, email, rut, job, job_motto, legacy_project, pet_project, hacker_quote, favorite_kpop_group)
    normal_talk(FireProfile.get_profile(id), data)
  end
end

### help: *< check | finger >* *< @user | me >* --- Revisa la información de empleado ENERGON del usuario especificado.
module GetProfile
  extend Voice

  def self.exec(data)
    user_id = case data.text
              when /(check|finger)\s<@(.*)>/
                user_id = ''
                if (match = data.text.match(/<@(.*?)>$/i))
                  user_id = match.captures[0]
                end
                user_id
              when /(check|finger) me/
                data.user
              end
    normal_talk(FireProfile.get_profile(user_id), data)
  end
end

### help: *< check | finger >* *< @user >* *< name | email | job | hacker | pet >* --- Revisa un atributo especifico del perfil de empleado en ENERGON.
module GetDetail
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
    p info
    normal_talk(info, data)
  end
end
