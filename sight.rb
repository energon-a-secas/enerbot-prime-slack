class Directive
  def self.serve(text, channel)
    case text
    when /no eventos/
      Idle.quote(channel)
    when /(bail[ea]|directive three)/
      Dance.disco(channel)
    when /canta/
      Sing.song(channel)
    when /recomienda una canci[oó]n/
      Sing.recommend(channel)
    end
  end
end