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

module Security
  def privileges_check(user)
    ENV['SLACK_BOT_ADMINS'].include? user
  end
end
