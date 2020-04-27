if not sys then
	sys = {}
	sys.headers = {
		["Cookie"] = ranga.gettoken(),
		["Connection"] = "close",
		["Content-Type"] = "application/x-ranga-proto-client",
	}

	local http = require "socket.http"
	local ltn12 = require "ltn12"

	local insertHeaderItem = function(headers, v)
		index1, index2 = string.find(v, ": ")
		if index1 ~= nil then
			headers[string.sub(v, 1, index1 - 1)] = string.sub(v, index2 + 1)
		end
	end

	sys.disp = function(section, target, args)
		local postdata = ''

		if not args then args = {} end
		for k, v in pairs(args) do
			postdata = postdata .. v .. "\n"
		end

		local headers = sys.headers
		headers["Content-Length"] = string.len(postdata)

		local respbody = {}
		local x, code = http.request {
			method = "POST",
			url = "http://127.0.0.1/cgi-bin/disp?section=" .. section .. "&target=" .. target,
			source = ltn12.source.string(postdata),
			headers = sys.headers,
			sink = ltn12.sink.table(respbody)
		}

		if x ~= 1 or code ~= 200 then
			return nil
		end

		respbody = table.concat(respbody)

		headers = {}
		local index1, index2 = string.find(respbody, "\n\n")
		local payload = string.sub(respbody, index2 + 1)
		local h = string.sub(respbody, 1, index1 - 1)

		while true do
			index1 = string.find(h, "\n")
			if not index1 then
				insertHeaderItem(headers, h)
				break
			else
				insertHeaderItem(headers, string.sub(h, 1, index1 - 1))
				h = string.sub(h, index1 + 1)
			end
		end

		return headers, payload
	end

	sys.config = function(target, args)
		return sys.disp("config", target, args)
	end

	sys.action = function(target, args)
		return sys.disp("action", target, args)
	end

	sys.query = function(target, args)
		return sys.disp("query", target, args)
	end
end
