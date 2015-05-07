http = require('http-utils')


requestPayload = 'GET /abc/?a=1&b=2#c HTTP/1.1\r\nHeader1: 123\r\nHeader2: abc\r\n\r\n{"body": 123}\r\n'

request = http.parseRequest(requestPayload)
print('Method: ' .. request.method)
print('Path:   ' .. request.path)
print('Body:   ' .. request.body)
