ranga.luaload("ranga.ext.base/utils/sys.lua")

action = os.getenv("RANGA_CRON_ARGS");
if action == "restart" then
	sys.action("restart", {"wireless"});
elseif action == "rfkill.down" then
	sys.action("rfkill", {"wldown"});
elseif action == "rfkill.up" then
	sys.action("rfkill", {"wlup"});
end
