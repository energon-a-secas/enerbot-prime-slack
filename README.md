# Slack-CL4P-TP

I had the need of a simple chat bot that acted like Claptrap from Borderlands and "sing" something because hell yeah, so here it is.

_Just add the icon and give it the name and the magic will be real._

# Distribution of files:

Some functions are couple in modules inside of the following files, don't worry i don't get it either. 

## Senses

### Perception

- Space Perception: dedicated to thermal sensation obtain from the weather report from _.

## Other stuff

### Mind:

- Conscious: makes the proper Slack Client configuration.
- Thought: Selects channel and thread when a message is send.
- Judgment: #TODO
- Memory: #TODO
- Mood: event and thermal based moods, that will determine how and when it should respond.
 
### Will:

- Directive: actions to execute.
- Ethics: #TODO
- Personality: #TODO

## Functions:



### voice:

- Voice: defines the client interaction with Slack to post messages.

## Actions:

Under the directory of 'actions', the defined actions (ruby scripts) must be included on the core file and include de module of voice.

```
class Directive
  def self.serve(data)
    case data.text
    when /example1/
      # (...)
    when /regex_for_invoke_the_new_script/
      Example.demo(data)
    end
  end
end
```

```
require './voice'

# When there's nothing to say, say something
module Example
  extend Voice
  def self.demo(data)
    text = 'hello is the demo'
    normal_talk(text, data)
  end
end
``` 