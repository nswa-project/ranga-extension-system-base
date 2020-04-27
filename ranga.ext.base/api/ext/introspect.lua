ranga.proto.prepare()
ranga.proto.header("code", "0")
ranga.proto.content()

a = io.read("*l")
print("> ext: " .. a)

b = io.read("*l")
if not b then b = '' end
print("> dir: " .. b)
print('')

for k, v in pairs(ranga.lsdir(a .. "/api/" .. b:gsub('%.', '/'))) do
	if v == 0 then
		print("+ " .. k)
	elseif v == 1 then
		print("@ " .. k:gsub("%.[^%.]*$", ''))
	end
end
