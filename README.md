Maigis-Slack
========
![This software is Blessed](https://img.shields.io/badge/blessed-100%25-770493.svg)

This new version comes from the history of Enerbot and his companion, a young DevOps. The little bot wanted to sing but the former DevOps in charge couldn't achieve that functionality in the old ways. He must evolve first... and use a lot of modules in the process.

Distribution of files:
---
The first step was to learn from the past and fix the little things. Sadly, the young DevOps couldn't find a good way to that task. Until he remembers, that in fact himself is separated and each one handles a specific function. 

Therefore, his soul that is composed of mind, will, and emotions should fit at some point in the new needs of Enerbot. Maybe.

*TL;DR: Some functions are coupled in modules inside of the following files, don't worry I don't get it either.*

Mind
---------
- Conscious: configures and initialize the Slack Client (RealTime or Web)
- Judgment: redirects and selection of data.
- Memory: define the methods needed for a proper interaction with the MongoDB.
- Mood: the weather of Santiago, Chile will impact the performance.

Senses
---------

- Perception:
- Sight:

And the rest:
---------

- Client: loads the 'yml.cnf' file under config that sets the variables with the specified environment (development, staging, and production) and initialize the 'main.rb'.
- Directives: defines the modules (scripts) added to the bot and the regex need it to execute them.
- Main: the beautiful loop that it's listening constantly on Slack.
- Voice: defines the client interaction with Slack to post messages.

How to configure the bot:
---------

The file 'client.rb' use the Enviable gem that helps you to configure environment variables from your favorite YAML file. There's an example inside the config directory called 'yml.cnf.example'. Define your variables on a new yml.cnf in the same directory and you are good to go.

How to define an action:
---------

Create under the directory of 'actions' the script that you wanted, let's say `example.rb`, this file must be defined like this:

```
# example.rb
require './voice'

# Description of what this module does.
module Example
  extend Voice
  def self.exec(data)
    text = 'hello is the demo'
    normal_talk(text, data)
  end
end
```

When you require the file 'voice' it's for using the functions defined inside of it. In a normal case, you will be using the "normal_talk" method that requires two arguments:

- Text: this should be the result provided by the script o just send some text to slack when matching the desired criteria.
- Data: is passed as an obligatory argument because it contains the data provided by slack, that includes; text, channel, user, timestamp and a lot more. You should worry about this because data is handled by the Voice module.

And you should be asking yourself, where do I put the criteria to respond with my script?

Inside of the 'Directive' file, you must include the file that you added and then define inside of the hash (func) the regex and the name of the module.

In a short way, it should look like this:

```
require './actions/sing'
require './actions/dance'

class Directive
  def self.serve(data)
    func = { /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song }
    text = data.text
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end
```

After you add the require with the path of the file, and set the matching criteria with the module name inside the hash, like this:

```
require './actions/sing'
require './actions/dance'
require './actions/example'

class Directive
  def self.serve(data)
    func = { /(bail[ea]|directive three)/ => Disco_dance,
             /canta/ => Sing_song,
             /matching criteria/ => Example }
    text = data.text
    func.keys.any? { |key| func[key].exec(data) if key =~ text }
  end
end



```