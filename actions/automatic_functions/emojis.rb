require './lib/message_slack'
require './lib/format_slack'

# A little hash and a bunch of regular expressions.
module AutoEmoji
  extend MessageSlack
  extend FormatSlack

  def self.exec(data, chn = nil, cts = nil)
    text = data.respond_to?(:text) ? data.text : data
    channel = chn.nil? ? data.channel : chn
    ts = cts.nil? ? data.ts : cts

    check = {
      /((bue(n|nos)|(good|gud)) (d[íi](a|as))|morni(n|ng))/i => %w[coffee beers glass_of_milk baby_bottle croissant ocean wave tea sandwich].sample(2),
      /(bienvenid[oa]|welcome)/i => %w[wave ocean clapping2 blobdance blob-clap].sample(2),
      /(enerbot.*\s@\s|\sasado|@enerbot|deeplearning|(alexa|siri)$)/i => %w[angry unamused fairy space_invader face_with_symbols_on_mouth imp rage].sample(2),
      /((ando|sigo|estoy) en reu)/i => %w[sad_eyes cry laughcry crying_cat_face f].sample(2),
      /(LosJuevesSonDeGlobant|AdivinaAlGlober)/i => %w[starmeup brightened_star star heart meow-globey].sample(3),
      /(cerveza|chela)/i => %w[grin robot_face hugging_face beer].sample(2),
      /(jojo|giorno|nani[\?!])/i => %w[jojomoment jp].sample(2),
      /((mata|elimina) a)/i => %w[peace cat2 dove_of_peace speak_no_evil].sample(2) + %w[agiteflip heart agite],
      /\s(ist der)/i => %w[de],
      /enerbot.*(te quiero|am(o|or)|beso)/i => %w[blob_aww kiss heart heart_eyes heartbeat allo_love].sample(2),
      /(enerbot|verguenza).*(verguenza|enerbot)/i => %w[blush2 meow-blush flushed zipper_mouth_face].sample(1),
      /(dormido|enerbot).*(enerbot|dormido)/i => %w[sleepy zzz sleeping meow-sleeping].sample(1)
    }

    result = check.keys.find { |key| check[key] if key.match(text) }

    unless result.nil?
      emoji_list = check[result]
      emoji_list&.each { |e| add_reaction(e, channel, ts) }
    end
  end
end
