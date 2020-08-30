# Module for regular expressions that are common
module FormatSlack
  def get_values_from(text, type = 'user')
    pattern = case type
              when 'user'
                /<@(.*)>/
              when 'channel'
                /<#(.*)\|(.*)>/
              end
    text.match(pattern)
  end

  def attachment_style(text, pretext: 'Test', color: '#e93d94', author: '')
    attachment = []
    attachment << {
      "color": color,
      "author_name": author,
      "pretext": pretext,
      "text": text
    }
    attachment
  end

  def process_data(data)
    match = data.match(/^\\.*?\s(\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i)
    unless match.nil?
      channel = match.captures[2] || match.captures[3]
      text = match.captures[5]
      check_ts = channel.match(/(.*)-(\d*\.\d*)/)
      channel = check_ts.captures[0] unless check_ts.nil?
      thread = check_ts.captures[1] unless check_ts.nil?
    end
    [text, channel, thread]
  end
end
