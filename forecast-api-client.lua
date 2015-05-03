utils = require('http-utils')


FORECAST_API_IP = "192.168.1.82"
FORECAST_API_PORT = 5000


conn = net.createConnection(net.TCP, 0)

conn:on("receive", function(conn, payload)
    forecast_data = utils.getResponseBodyJSON(payload)
    if not forecast_data["forecast"] then
        return
    end

    temperatures = forecast_data["forecast"]
    table.sort(temperatures)
    print("Temperature max: " .. temperatures[#temperatures])
    print("Temperature min: " .. temperatures[1])
end)

conn:connect(FORECAST_API_PORT, FORECAST_API_IP)

conn:send("GET / HTTP/1.1\r\n\r\n")
