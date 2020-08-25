require './voice'
require './will/personality'

# Weird workaround
def search_manual(type, path = 'actions/*.rb')
  cmd = case type
        when 'HELP' then 'enerbot'
        when 'ADMIN' then ''
        when 'SCRUM' then 'enerscrum'
        end

  text = '>>>*Ayuda - Ajuda - Help* :heart:'
  input = "### #{type}:"
  files = Dir.glob(path)
  files.each do |file|
    next if file == 'actions/help.rb'

    File.open(file).each do |line|
      matches = line.match(/(#{input})(.*)/i)
      text += "\n#{cmd}#{matches[2]}" if matches
    end
  end
  text += "\n\n:star: *For more information use the '-f' or '--full' flag.*"
  text
end

# Regular features
module SystemHelp
  extend Voice

  def self.exec(data)
    text = search_manual('HELP')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    normal_talk(text, data)
  end
end

# Scrum features
module ScrumHelp
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png')
    text = search_manual('SCRUM', 'actions/scrum/*.rb')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    normal_talk(text, data)
    event_look_revert
  end
end

# Doctor features
module DoctorHelp
  extend Voice
  extend Persona

  def self.exec(data)
    event_look_set('ENER-DOC', 'https://i.imgur.com/LjhmSeI.png')
    text = search_manual('DOCTOR', 'actions/doctor/*.rb')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    normal_talk(text, data)
    event_look_revert
  end
end

# Root features
module FunctionsHelp
  extend Voice

  def self.exec(data)
    text = search_manual('ADMIN')
    normal_talk(text, data)
  end
end
