Cogbot plugins list
=======================

```
Plugin      Command / Output
----------  -----------------------------------------------------------------
dice        .roll
                outputs "<user> rolls <x>" where x is between 1 and 100

exec        .do <command>
                exec <command> on the bot host
                <command is restricted to the list:
                - psaux
                - df
                - last
                - free
                - who
                - uptime
                - f (for fortune)

fortune     .f
                output a random fortune


google      .g <searchterm>
                output first result for a google search

manager     .m list
                lists loaded plugins
            .m load <plugin>
                load plugin <plugin>
            .m unload <plugin>
                unload plugin <plugin>
            .m reload <plugin>
                reload plugin <plugin>
                uselful when changing plugin code
            .m set <plugin> <option> <value>
                makes possible to change option values for <plugin>

rubygems    .r <searchterm>
                searches on Rubygems API and returns the first 4 matches

shorturl    .short <url>
                returns a short url for <url> using tinyurl.com

stack       .s <term>
overflow        returns result of a search on <term> from stack overflow

tweet       .t search <term>
                returns the 3 first matching tweets matching <term>

urban       .u <term>
                finds the definition of <term> according to the Urban Dictionary

ip          .ip
                gets the ip of the server where the bot runs


Listeners       Action
--------------  --------------------------------------------------------------
gitlistener     for github webhooks, advertises the aggregate addition, 
                    modification and deletion from commits

trellolistener  listens to Trello webhooks and announces any kind of change

rss             polls multiple RSS feeds and announces new items 
                    to multiple channels
```
