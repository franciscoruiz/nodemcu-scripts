local module = {}


module.METHODS = {}
module.METHODS.GET = 'get'
module.METHODS.POST = 'post'


function module.parseRequest(request_payload)
    request = {}

    lines = {}
    request_payload.gsub("[^\r\n]+", function (l)
        lines[#lines+1] = l
    end)

    request_line = lines[1]
    matches = string.gmatch(request_line, "%S+")
    request.method = matches():lower()
    request.path = matches()

    request.headers = {}
    return request
end


function module.getResponseBody(response_payload)
    headers_end_index = response_payload:find("\r\n\r\n")
    if headers_end_index then
        body_start_index = headers_end_index + 4
        response_body = response_payload:sub(body_start_index)
    else
        response_body = nil
    end
    return response_body
end


function module.getResponseBodyJSON(response_payload)
    response_body = module.getResponseBody(response_payload)
    if not response_body then
        return {}
    end

    status, data = pcall(function ()
        return cjson.decode(response_body)
    end)
    if not status then
        print("ERROR: " .. data)
        data = {}
    end
    return data
end


return module
