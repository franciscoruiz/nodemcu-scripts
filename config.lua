-- Storage and retrieval utilities to manage configuration for the node

local module = {}

function module.getConfig()
    return {ssid: nil, pwd: nil}
end


function module.saveConfig(config)
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


function module.startConfigServer(callback)
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid: 'NodeMCU Configuration', pwd: '1234'})
    print('Starting configuration server on ' .. wifi.ap.getip())

    configuration_server = net.server.createServer(net.TCP)
    configuration_server:listen(80, function (conn)
        conn:on('receive', function (conn, payload)
            request = parseRequest(payload)
            if request.method == 'GET' then
                sendConfigForm(conn)
            else
                config = parseConfigRequest(payload)  -- Assume it's valid
                configuration_server:close()
                module.saveConfig(config)
                callback(config)
            end
        end)
    end)
end


return module
