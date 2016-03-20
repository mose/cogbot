Cogbot Changelog
===================

### v0.1.5 - 2016-03-20
- add config support for SASL
- add a rss plugin

### v0.1.4 - 2015-11-23
- removed a debug require from twitter plugin

### v0.1.3 - 2015-11-20
- add more listened actions on trello listener plugin
- update dependencies

### v0.1.2 - 2015-03-16
- add link to status on twitter plugin search results
- add age of status in twitter plugin
- fix bug on tweet search results that are more than one day old or less than one minute
- add a weak protection for the manager plugin (which anyways should only be used in development mode)
- update dependencies on cinch and eventmachine (fixing a mem leak issue)
- add a trello listener plugin, for receiving hooks from Trello
- change the git listener to listen only on http://host:ip/gitlistener (to avoid confuse with the trello listener)

### v0.1.1 - 2015-01-28
- avoid disclose local path in nmanager plugin when plugin not found
- fix setup message config.yaml to cogbot.yaml

### v0.1.0 - 2015-01-08
- upgrade dependency to cinch 2.0.6 to 2.2.2
- upgrade other gems as well
- fix all plugins for upgrade
- handle compat with ruby 2.2

### v0.0.3 - 2013-07-29

### v0.0.2 - 2013-04-03

