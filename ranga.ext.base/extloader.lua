#!/usr/bin/lua

local _loadfile=loadfile
local _require=require
local _io=io

local function sandbox()
	arg=nil

	debug.debug=nil
	debug.getfenv=getfenv
	debug.getregistry=nil

	io={close=io.close, read=io.read, write=io.write, flush=io.flush, stdout=io.stdout, stderr=io.stderr}

	os.execute=nil
	os.remove=nil
	os.rename=nil
	os.tmpname=nil

	package.loaded.io=io
	package.loaded.package=nil
	package=nil

	--require=nil
	load=nil
	dofile=nil
	loadfile=nil
	module=nil

	setfenv = nil
	getfenv = nil
end

package.cpath = "/usr/lib/lua/lib?.so"
require "nswa"
package.cpath = "/usr/lib/lua/?.so"

local allow_libs = { ["coroutine"]=true, ["math"]=true, ["string"]=true, ["table"]=true, ["mime.core"]=true, ["socket.core"]=true, ["socket"]=true, ["ltn12"]=true, ["mime"]=true, ["socket.http"]=true, ["socket.tp"]=true, ["socket.url"]=true, ["socket.headers"]=true }

if not ranga then ranga = {} end
ranga.proto = {}

require = function(lib)
	if allow_libs[lib] then
		return _require(lib)
	end
	return nil
end

ranga.luaload = function(x)
	x = x:gsub("%.%.", "")
	local f = assert(_loadfile("/extensions/" .. x))
	f()
end

ranga.openfile = function(x, mode)
	if mode == nil then mode = "r" end
	x = x:gsub("%.%.", "")
	return _io.open("/extensions/" .. x, mode)
end

ranga.tmpfile = function(x, mode)
	if mode == nil then mode = "w" end
	x = x:gsub("%.%.", "")
	return _io.open("/tmp/_ext/" .. x, mode)
end

ranga.tmpfree = function(x)
	x = x:gsub("%.%.", "")
	_unlink("/tmp/_ext/" .. x)
end

ranga.gettoken = function()
	local f = _io.open("/tmp/ranga_etoken", "r")
	if f == nil then return "" end
	token = "RETM=" .. f:read("*a")
	f:close()
	return token
end

ranga.checkuser = function()
	local token = os.getenv("HTTP_COOKIE")
	if not token then return false end

	local p, l = string.find(token, "USER_TOKEN=")
	if not p then return false end

	token = string.sub(token, p + l)

	local f = _io.open("/tmp/ranga_utoken", "r")
	if not f then return false end

	local ttoken = f:read()
	f:close()

	if ttoken ~= token then
		return false
	end

	return true
end

ranga.proto.prepare = function()
	io.write('Content-type: text/plain; charset=utf-8\n\n')
end

ranga.proto.header = function(k, v)
	io.write(k)
	io.write(': ')
	io.write(v)
	io.write('\n')
end

ranga.proto.content = function()
	io.write('content-type: extensionAPI\n')
	io.write('\n')
	io.flush()
end

local f = assert(loadfile(arg[1]))
sandbox()
f()
