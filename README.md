# CL4P-TP-Slack

This new version comes from the history of Enerbot and his companion, a young DevOps. The little bot wanted to sing but the former DevOps in charge couldn't achieve that functionality in the old ways. He must evolve first... and use a lot of modules in the process.

# Distribution of files:

The first step was to learn from the past and fix the little things. Sadly, the young DevOps couldn't find a good way to that task. Until he remembers, that in fact himself is separated and each one handles a specific function. 

Therefore, his soul composes of mind, will, and emotions should fit at some point in the new needs of functionalities.

*TL;DR: Some functions are coupled in modules inside of the following files, don't worry I don't get it either.*

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

Variables that you should be aware of:

```
ENV['KEY']
ENV['KEY_KEY']
ENV['TOKEN']
ENV['TOKEN_KEY']
```