# Cogbot

Cogbot is an irc bot written in ruby based on [Cinch bot framework](https://github.com/cinchrb/cinch).

It has been in servvice at [Code Green](http://codegreenit.com) since summer 2012 and his stability
is unquestionned. It is used with a collection of custom plugins that are focused on helping a coding
team that uses irc as a main shared communication space:

* git notifications pushed on the channel
* redmine issues polled from our redmine and announced
* commands to ask rubygems or stack overflow
* the urban dictionary to make us laugh
* and some other more or less used features

## Installation

    gem install cogbot

## Usage

At first launch:

    cogbot start

you will be prompted to create a configuration file in ~/.cogbot/cogbot.yml
When this is done you can launch again and it will just run according to your configuration.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

* write some documentation of the commands of plugins
* write tests

## Licence

MIT license

Copyright (c) 2012-13 mose at Code Green
