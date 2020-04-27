if not cgiutils then
	cgiutils = {}

	cgiutils.parsequery = function(buf)
		local map = {}
		local decode = function(s)
			local s = s:gsub('+', ' ')
			s = s:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
			return s
		end
		buf:gsub('([^&=]+)=([^&=]*)&?', function(key, value) map[decode(key)] = decode(value) end)
		return map
	end
end
