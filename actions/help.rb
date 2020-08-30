require './lib/message_slack'
require './lib/image_slack'
require './lib/format_slack'

# Menu builder
module HelpMenu
  extend MessageSlack
  extend FormatSlack
  def self.file_search(type, path = 'actions/**/*.rb')
    files = Dir.glob(path).map { |name| name unless name == 'actions/help.rb' }

    text = "\n"
    input = "### #{type}:"
    files.each do |file|
      next if file.nil?

      File.open(file).each do |line|
        matches = line.match(/(#{input})(.*)/i)
        text += "\n#{matches[2]}" if matches
      end
    end

    text += "\n\n:star: *For more information use the '-f' or '--full' flag.*"
    text.split("\n").sort.join("\n")
  end
end

# Common functions help menu
module CommandHelp
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    author = 'Ayuda - Ajuda - Help :heart:'
    text = HelpMenu.file_search('HELP')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    message = attachment_style(text, pretext: 'enerbot +', author: author)
    send_attachment(message, data)
  end
end

# Root functions help menu
module RootHelp
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    author = 'Ayuda - Ajuda - Help :heart:'
    text = HelpMenu.file_search('ADMIN')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    message = attachment_style(text, pretext: 'enerbot +', author: author)
    send_attachment(message, data)
  end
end

# Doctor functions help menu
module DoctorHelp
  extend MessageSlack
  extend FormatSlack

  def self.exec(data)
    author = 'Ayuda - Ajuda - Help :heart:'
    text = HelpMenu.file_search('DOCTOR')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    message = attachment_style(text, pretext: 'enerbot +', author: author)
    send_attachment(message, data)
  end
end

# ZENBOT functions help menu
module ZenHelp
  extend MessageSlack
  extend FormatSlack
  extend ImageSlack

  def self.exec(data)
    event_look_set('Zenbot', 'https://i.imgur.com/Fswhv2H.png')
    author = 'Ayuda - Ajuda - Help :heart:'
    text = HelpMenu.file_search('ZENBOT')
    text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
    message = attachment_style(text, pretext: '_+', author: author)
    send_attachment(message, data)
    event_look_revert
  end
end
