# Selection that should be improved
module Thought
  def discern_end(data)
    @thread = if data.respond_to? :thread_ts
                data.ts
              else
                ''
              end
    @channel = if data.respond_to? :channel
                 data.channel
               else
                 data
               end
  end
end

class CriticalThinking
  def initialize(data)
    user = data.user
    text = data.text
    channel = data.channel

    register("#{user}, #{channel}: #{text}")
  end

  def register(*args)
    @var < args
  end

  def count_topics(*args)
    tokens = args.join(" ").split(/\s/)
    tokens.inject(Hash.new(0)) {|counts, token| counts[token] += 1; counts }
  end

  def popular_topics
    count_topics(@var)
  end
end

#Judgment
