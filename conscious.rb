# Directives
class Directive
  def self.serve(data)
    text = data.text
    channel = data.channel
    thread = data.ts

    case text
    when /no eventos/
      Idle.quote(channel, thread)
    when /(bail[ea]|directive three)/
      Dance.disco(channel, thread)
    when /canta/
      Sing.song(channel, thread)
    when /recomienda una canci[oó]n/
      Sing.recommend(channel, thread)
    end
  end
end