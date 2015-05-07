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

    configEncoded = file.read()
    file.close()
    local config = cjson.decode(configEncoded)
    return config
end


function module.saveConfig(new_configuration)
    configEncoded = cjson.encode(new_configuration)
    print("Saving configuration: " .. configEncoded)
    file.open(CONFIG_FILE_NAME, 'w')
    file.write(configEncoded)
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
                local userConfig = parseConfigRequest(payload)  -- Assume it's valid
                configuration_server:close()
                module.saveConfig(userConfig)
                callback(userConfig)
            end
        end)
        conn:on('sent', function (conn) conn:close() end)
    end)
end


function sendConfigForm(conn)
    file.open('config-form.html', 'r')
    form = file.read()
    file.close()
    conn:send(form)
end


function parseConfigRequest(requestPayload)
    request_data = http.getResponseBodyJSON(requestPayload)
    return requestPayload;
end


return module
