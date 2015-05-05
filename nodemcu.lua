require('config')


function main(configuration)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(configuration)

    tmr.alarm(1, 5000, 1, function ()
        print('Sending temperature')
    end)
end


configuration = config.getConfig()
if configuration then
    main(configuration)
else
    config.startConfigServer(main)
end
