require './lib/message_slack'
require './lib/image_slack'
require './lib/format_slack'

# Menu builder
module HelpMenu

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
    new_text = text.split("\n").sort.join("\n")
    new_text + "\n\n:star: *For more information use the '-f' or '--full' flag.*"
  end
end

module GeneralHelp
  extend MessageSlack
  extend FormatSlack
  extend ImageSlack

  def self.exec(data)
    # author = 'Ayuda - Ajuda - Help :heart:'

    check = data.text.match(/(\\HELP|ENERBOT|SCRUM|DOC|ZENBOT)/i)
    unless check.nil?
      types = {
          'HELP' => ['\\', 'Advance Tutorial', 'https://i.imgur.com/rs3nYG7.png'],
          'ENERBOT' => ['enerbot', 'Ayuda - Ajuda - Help', 'https://i.imgur.com/yQLi8YZ.png'],
          'SCRUM' => ['enerscrum', 'Certified Digital Expert', 'https://i.imgur.com/bSGaXSX.png'],
          'DOC' => ['enerdoc', 'ENERDOC', 'https://i.imgur.com/LjhmSeI.png'],
          'ZENBOT' => ['Zenbot', 'Zenbot', 'https://i.imgur.com/Fswhv2H.png']
      }
      help_target = check[1].upcase.gsub('\\', '')
      menu_attr = types[help_target]
      event_look_set(menu_attr[1], menu_attr[2]) unless menu_attr.nil?
      text = HelpMenu.file_search(help_target)
      text = text.gsub(/\s---.*$/, '') unless data.text =~ /(f|full)/
      message = attachment_style(text, pretext: "#{menu_attr[0]} +")
      send_attachment(message, data)
      event_look_revert unless menu_attr.nil?
    end
  end
end
