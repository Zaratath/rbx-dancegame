# rbx-dancegame
Parsing .chart file data using https://github.com/csqrl/luau-gh-chart, which is licensed under MIT. The license and copyright disclosure has been included as a comment in the .rbxmx lib file.

# Notes
- Currently, syncing player songs together will be affected by the player's latency to the server. There shouldn't be a noticeable de-sync however depending on variables such as the player's distance to the server may be 50 to 200 miliseconds out of sync with the server. This can be fixed by sending events and collecting the responses to measure the player's latency to the server, and using that to offset the timestamp when sending a song to clients.

- Clients authoritatively dictate what beats they've hit at what time, the server accepts their results. Honest clients will notify the server of their own missed inputs. I don't view this as a security flaw: this type of game would be very easy to cheat on with any form of script injection by way of design, the client would just have to pretend they're playing the song perfectly. It would be virtually impossible to implement any meaningful cheat detection, thus it's easiest to just assume clients are being honest.