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
```
