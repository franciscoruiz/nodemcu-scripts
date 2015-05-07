local module = {}


module.METHODS = {}
module.METHODS.GET = 'get'
module.METHODS.POST = 'post'


function module.parseRequest(requestPayload)
    request = {}

    request_header, request.body = unpack(split(requestPayload, "\r\n\r\n"))
    request_header_lines = split(request_header, "\r\n")

    request.method, request.path, request.protocol = unpack(split(request_header_lines[1], " "))

    table.remove(request_header_lines, 1)
    request.headers = request_header_lines
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


-- Utilities

function split(str, separator)
    return _split(str, separator, 1, {})
end


function _split(str, separator, start_index, partial_result)
    if start_index >= #str then
        return partial_result
    end

    sep_start, sep_end = str:find(separator, start_index, true)
    if sep_start == nil then
        sep_start = #str + 1
        sep_end = sep_start
    end

    part = str:sub(start_index, sep_start)
    append(partial_result, part)

    return _split(str, separator, sep_end + 1, partial_result)
end


function append(array, element)
    array[#array + 1] = element
end


return module
