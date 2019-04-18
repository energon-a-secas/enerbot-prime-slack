# Slack-CL4P-TP

Simple chat bot base on Claptrap from Borderlands. Just add the icon and give it the name and the magic will be real.

## Distribution of files:

### mind:

- Conscious: Slack Client configuration.
- Thought: select channel and thread.
- Judgment: #TODO
- Memory: #TODO

 
### will:

- Directive: actions to execute.
- Ethics: #TODO
- Mood: #TODO
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