NodeMCU mDNS Client Test
====

Trying to make mDNS queries on NodeMCU, using [my fork of nodemcu-mdns-client](https://github.com/joedski/nodemcu-mdns-client).  I wish I had more time to devote to learning enough to actually write my own client rather than just bodging someone else's but such is life.  Maybe my work will help others?



## Usage

- Create `credentials.lua` as described below.
- Upload all the Lua files to your NodeMCU board.
- Connect to the serial console.
- Enter `application.main()` and watch stuff happen.


### credentials.lua

Your `credentials.lua` file should look something like this:

```lua
local credentials = {
  wifi = {
    apname = "YOUR WIFI NETWORK NAME",
    appassword = "YOUR WIFI NETWORK PASSWORD"
  }
}

return credentials
```
