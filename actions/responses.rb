require './voice'

# When there's nothing to say, say something
module ResponseHi
  extend Voice
  def self.exec(data)
    text = case data.text
           when 'holi'
             'Holiwis'
           when /i love you/
             "I love you #{rand 10_000}"
           end

    normal_talk(text, data)
  end
end
