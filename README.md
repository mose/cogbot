# Cogbot

[![Gem Version](http://img.shields.io/gem/v/cogbot.svg)](http://rubygems.org/gems/cogbot)
[![Downloads](http://img.shields.io/gem/dt/cogbot.svg)](https://rubygems.org/gems/cogbot)
[![Dependency Status](https://img.shields.io/gemnasium/mose/cogbot.svg)](https://gemnasium.com/mose/cogbot)
[![Code Climate](http://img.shields.io/codeclimate/github/mose/cogbot.svg)](https://codeclimate.com/github/mose/cogbot)
[![Inch](https://inch-ci.org/github/mose/cogbot.svg)](https://inch-ci.org/github/mose/cogbot)

Cogbot is an irc bot written in ruby based on [Cinch bot framework](https://github.com/cinchrb/cinch).

It has been in service at [Code Green](http://codegreenit.com) from 2012 to 2013 and his stability
was unquestionned. It is used with a collection of custom plugins that are focused on helping a coding
team that uses irc as a main shared communication space:

* git notifications pushed on the channel
* redmine issues polled from redmine and announced
* commands to ask google, rubygems or stack overflow
* the urban dictionary to make us laugh
* a twitter search plugin
* a trello webhooks listener
* and some other more or less used features


## Installation

    gem install cogbot

## Usage

At first launch:

    cogbot start

you will be prompted to create a configuration file in ~/.cogbot/cogbot.yml
When this is done you can launch again and it will just run according to your configuration.

## Configuration

Some plugins require extra config parameters:

Git and trello webhook listeners use a small eventmachine http server, which is only launched if the configuration is present:

    server:
      ip: x.x.x.x
      port: xxxxx

Twitter plugin requires to have credentials set:

    tweet:
      consumer_key: "xxx"
      consumer_secret: "xxx"
      access_token: "xxx"
      access_token_secret: "xxx"

Trello plugin has some config too, for knowing where to announce the trello changes. The webhook has to be setup independantly, it's quite easy to declare by using postman.

    trello:
      announce:
      - "#trello-announces"

Then in Trello, using the API, you can set a hook to send events to http://ip:port/trellolistener

## Todo

- document each plugin
- add multi-entrypoints system for webhooks listener
- add a users database
- add a credentials system

## Development

    git clone git@github.com:mose/cogbot.git
    cd cogbot/
    bundle install --path vendor
    bundle exec ruby -Ilib bin/cogbot start

To reload plugins while developing, you can issue, on a channel where your bot is sitting:

    .m reload myplugin

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

Copyright (c) 2012-15 mose at mose
