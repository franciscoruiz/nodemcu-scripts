-- Storage and retrieval utilities to manage configuration for the node
http = require('http-utils')


-- Set module name as parameter of require
local modname = ...
local module = {}
_G[modname] = M


CONFIG_FILE_NAME = 'config.json'


function module.getConfig()
    if not file.open(CONFIG_FILE_NAME, 'r') then
        file.open(CONFIG_FILE_NAME, 'w')
        file.write('{}')
        file.close()
        file.open(CONFIG_FILE_NAME, 'r')
    end

    config_encoded = file.read()
    file.close()
    config = cjson.decode(config_encoded)
    return config
end


function module.saveConfig(config)
    config_encoded = cjson.encode(config)
    print("Saving configuration: " .. config_encoded)
    file.open(CONFIG_FILE_NAME, 'w')
    file.write(config_encoded)
    file.close()
end


function module.startConfigServer(callback)
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid='NodeMCU Configuration', pwd='1234'})
    print('Starting configuration server on ' .. wifi.ap.getip())

    configuration_server = net.createServer(net.TCP)
    configuration_server:listen(80, function (conn)
        conn:on('receive', function (conn, payload)
            request = http.parseRequest(payload)
            if request.method == http.METHODS.GET then
                sendConfigForm(conn)
            else
                config = parseConfigRequest(payload)  -- Assume it's valid
                configuration_server:close()
                module.saveConfig(config)
                callback(config)
            end
        end)
        conn:on('sent', function (conn) conn:close() end)
    end)
end


function sendConfigForm(conn)
    file.open('config-form.html', 'r')
    form_file = file.read()
    file.close()
    conn:send(form_file)
end


function parseConfigRequest(request_payload)
    request_data = http.getResponseBodyJSON(request_payload)
    return request_payload;
end


return module
