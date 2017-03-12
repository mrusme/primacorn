![primacorn](primacorn.jpg "primacorn")

Test your crappy [Primacom](https://www.primacom.de) cable internet connection for packet losses and automatically report them to Primacom.

![demo](demo.gif "Demo")

## The story

After Primacom didn't manage it to provide the 200Mbit/s connection I signed up for within 5 months, they refused to let me withdraw from the contract and in addition started charging me money for a stranger's contract. Now the poor connection quality (with up to 80% packet loss on a regular basis) forced me to sign up for an additional VDSL contract.

I thought, it would be a good idea to keep Primacom informed about the awful quality of service they provide.

## The software

These scripts can be run in background (preferably on a piece of hardware like the Raspberry Pi) and check your internet connection by pinging an external host. As soon as packet loss is being detected, a Selenium script is being run which automatically fills out Primacom's customer [contact form](https://www.primacom.de/service/Kontaktformular) with your data and submits it. In addition to that, a log-file with all connection details is being written to `$HOME/primacorn.log`.

*Info: The scripts won't be able to report to Primacom if your connection has 100% packet loss!*

## The setup

### What you need:

- Linux, Ruby and Selenium with PhantomJS.
- A Raspberry Pi (or similar hardware) to run this stuff on.

### Usage:

`primacorn.rb` requires some environment variables to be set. Check out the `.env.example` in this repository. You can either set them manually (by prepending them to the `ruby /opt/...` command, e.g. `PRIMACOM_FIRSTNAME="John" PRIMACOM_... ruby /opt/...`) or source them from a file:

```bash
$ primacorn "google.com" 3 10800 "source $HOME/.primacorn.env && ruby /opt/primacorn/primacorn.rb"
```

The `primacorn` shell script requires the following arguments:

1. `host to ping`: The host (-name or IP) to ping, e.g. `google.com`.
2. `loss threshold`: The threshold after which the specified `command` should be executed. For example `3` would result for the script to wait for 3 packet losses before escalating.
3. `action interval`: The interval for escalations to occur, in seconds. If `command` was executed then the script would wait at least so many seconds until it would execute command another time, even if the threshold was hit.
4. `command`: The command to execute. In our case it's the `primacorn.rb` script.

## The warning

Dear Primacom, you're an awful company. Even more awful (and ridiculous!) than [German ISPs in general](https://twitter.com/mrusme/status/817638771118194688). I would like to inform you, that I've already started working on my next project: An AI bot that calls your customer service to report packet loss with speech. From multiple phone numbers. Simultaneously.

You have been warned.
