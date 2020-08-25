# Selection that should be improved
module Thought
  def discern_end(data, ts = nil)
    @thread = if data.respond_to? :thread_ts
                data.ts
              else
                ts unless ts.nil?
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
  rescue NoMethodError => e
    print "You probably didn't set the SLACK_BOT_ADMINS variable. Error: #{e.message}"
    false
  end
end
