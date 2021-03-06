local wifi = wifi
local mdnsclient = require "mdnsclient"
local credentials = require "credentials"

local application = {}

application.state = {
  hasIp = false,
  isConnected = false
}

application.timeout = 10.0

function application.main()
  print('Starting...!')
  wifi.setmode(wifi.STATION)
  wifi.sta.config({
    ssid = credentials.wifi.apname,
    pwd = credentials.wifi.appassword
  })
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, application.onGetIp)
  wifi.sta.connect(application.onConnect)
  print('Connecting to "'..credentials.wifi.apname..'"...')
  -- How to handle connect timeout?
end

function application.disconnect()
  -- Escape hatch.
  print('Disconnecting...')

  application.state.hasIp = false
  application.state.isConnected = false

  wifi.sta.disconnect(function (apinfo)
    print('Disconnected!\n> ')
  end)
end

function application.onConnect(apinfo)
  print('\nConnected!')
  print('  SSID: '..apinfo.SSID)
  print('  BSSID: '..apinfo.BSSID)
  print('  channel: '..apinfo.channel)

  application.state.isConnected = true
  application.queryLocalCosmos()
end

function application.onGetIp(ipinfo)
  print('Got IP: '..ipinfo.IP)

  wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
  application.state.hasIp = true
  application.queryLocalCosmos()
end

function application.queryLocalCosmos()
  if application.state.isConnected and application.state.hasIp then
    print('Querying the local cosmos for '..application.timeout..' seconds...')

    local ip = wifi.sta.getip()
    mdnsclient.query(nil, application.timeout, ip, application.onQueryMdns)
  end
end

function application.onQueryMdns(error, results)
  if error then
    print('Error completing mDNS Query: '..error)
  else
    print('Time\'s up!  mDNS Query Results:')
    for k,v in ipairs(results) do
      print('  '..k)
      print('    name: '..v.name)
      print('    service: '..v.service)
      print('    hostname: '..v.hostname)
      print('    port: '..v.port)
      print('    ipv4: '..v.ipv4)
      print('    ipv6: '..v.ipv6)
    end
  end
  application.disconnect()
end

return application
