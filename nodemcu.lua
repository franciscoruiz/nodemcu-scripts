config = nil
package.loaded["config"] = nil

config = require('config')


function main(configuration)
    config = nil
    package.loaded["config"] = nil
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config(configuration)

    tmr.alarm(1, 5000, 1, function ()
        print('Sending temperature')
    end)
end


for k, v in pairs(config) do
    print(k)
    print(v)
end
--configuration = config.getConfig()
--for k, v in pairs(configuration) do print(k .. ' = ' .. v) end
configuration = {ssid = 'abc'}
config.saveConfig(configuration)

--config.startConfigServer(main)
--if configuration then
--    main(configuration)
--else
--    config.startConfigServer(main)
--end
