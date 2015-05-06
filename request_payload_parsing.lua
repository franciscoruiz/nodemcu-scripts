request_payload = 'GET /abc/ HTTP/1.1\r\nHeader1: 123\r\nHeader2: abc\r\n\r\n{"body": 123}\r\n'

sep_start, sep_end = request_payload:find("\r\n\r\n", 1, false)
request_header = request_payload:sub(1, sep_start)
request_body = request_payload:sub(sep_end + 1)

request_header_lines = []
request_header:gsub("[^\r\n]+", function (match)
    request_header_lines[#request_header_lines + 1] = match
end)

request_line_chunks = []
request_header[1]:gsub('%S', function (match)
    request_line_chunks[#request_line_chunks + 1] = match
end)

method = request_line_chunks[1]
path = request_line_chunks[2]

print(request_payload)
print('Method: ' .. method)
print('Path:   ' .. path)
print('Body:   ' .. request_body)
