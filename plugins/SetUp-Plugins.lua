do
local function plugin_enabled( name )
	for k,v in pairs(_config.enabled_plugins) do
		if name == v then
			return k
		end
	end
	return false
end

local function plugin_exists( name )
	for k,v in pairs(plugins_names()) do
		if name..'.lua' == v then
			return true
		end
	end
	return false
end

local function list_all_plugins(only_enabled, msg)
	local text = ''
	local nsum = 0
	for k, v in pairs( plugins_names( )) do
		local status = '❬ ✘ ❭'
		nsum = nsum+1
		nact = 0
		for k2, v2 in pairs(_config.enabled_plugins) do
			if v == v2..'.lua' then
				status = '❬ ✓ ❭'
			end
			nact = nact+1
		end
		if not only_enabled or status == '❬ ✓ ❭'then
			v = string.match (v, "(.*)%.lua")
			text = text..nsum..'◦ '..v..' '..status..'\n'
		end
	end
	text = '`'..text..'`\n\n*✨ پلاگین های نصب شده :* _'..nsum..'_\n\n*✨ پلاگین های فعال :* _'..nact..'_\n\n*✨ پلاگین های غیرفعال :* `'..nsum-nact..'`'
	tdbot.sendMessage(msg.to.id, msg.id, 1, text, 1, 'md')
end

local function list_plugins(only_enabled, msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local text = ''
	local nsum = 0
	for k, v in pairs( plugins_names( )) do
		local status = '*❬ ✘ ❭*'
		nsum = nsum+1
		nact = 0
		for k2, v2 in pairs(_config.enabled_plugins) do
			if v == v2..'.lua' then
				status = '*❬ ✓ ❭*'
			end
			nact = nact+1
		end
		if not only_enabled or status == '*|✔|>*'then
			v = string.match (v, "(.*)%.lua")
			text = text..nsum..'◦ '..v..' '..status..'\n'
		end
	end
	text = M_START.."*ربات بروزرسانی شد.*"..EndPm
	tdbot.sendMessage(msg.to.id, msg.id, 1, text, 1, 'md')
end

local function reload_plugins(checks, msg)
	plugins = {}
	load_plugins()
	return list_plugins(true, msg)
end


local function enable_plugin( plugin_name, msg )
	print('checking if '..plugin_name..' exists')
	if plugin_enabled(plugin_name) then
		return
	end
	if plugin_exists(plugin_name) then
		table.insert(_config.enabled_plugins, plugin_name)
		print(plugin_name..' added to _config table')
		save_config()
		return reload_plugins(true, msg)
	else
	end
end

local function disable_plugin( name, msg )
	local k = plugin_enabled(name)
	if not k then
		return
	end
	if not plugin_exists(name) then
	else
		table.remove(_config.enabled_plugins, k)
		save_config( )
		return reload_plugins(true, msg)
	end
end

local function disable_plugin_on_chat(receiver, plugin, msg)
	if not plugin_exists(plugin) then
	end
	
	if not _config.disabled_plugin_on_chat then
		_config.disabled_plugin_on_chat = {}
	end
	
	if not _config.disabled_plugin_on_chat[receiver] then
		_config.disabled_plugin_on_chat[receiver] = {}
	end
	
	_config.disabled_plugin_on_chat[receiver][plugin] = true
	
	save_config()
end

local function reenable_plugin_on_chat(receiver, plugin, msg)
	if not _config.disabled_plugin_on_chat then
	end
	
	if not _config.disabled_plugin_on_chat[receiver] then
	end
	
	if not _config.disabled_plugin_on_chat[receiver][plugin] then
	end
	
	_config.disabled_plugin_on_chat[receiver][plugin] = false
	save_config()
end

local function MaTaDoRTeaM(msg, mr_roo)
if is_sudo(msg) then
if (mr_roo[1]:lower() == 'plist' ) or (mr_roo[1]:lower() == 'لیست پلاگین') then
	return list_all_plugins(false, msg)
end
--######################################################################--
end
if (mr_roo[1]:lower() == 'pl' ) or (mr_roo[1]:lower() == 'پلاگین') then
	if mr_roo[2] == '+' and ((mr_roo[4] == 'chat' ) or (mr_roo[4] == 'گروه' )) then
		if is_mod(msg) then
			local receiver = msg.chat_id_
			local plugin = mr_roo[3]
			print("enable "..plugin..' on this chat')
			return reenable_plugin_on_chat(receiver, plugin, msg)
		end
	end
	if mr_roo[2] == '+' and is_sudo(msg) then
		local plugin_name = mr_roo[3]
		print("enable: "..mr_roo[3])
		return enable_plugin(plugin_name, msg)
	end
	if mr_roo[2] == '-' and ((mr_roo[4] == 'chat' ) or (mr_roo[4] == 'گروه' )) then
		if is_mod(msg) then
			local plugin = mr_roo[3]
			local receiver = msg.chat_id_
			print("disable "..plugin..' on this chat')
			return disable_plugin_on_chat(receiver, plugin, msg)
		end
	end
	if mr_roo[2] == '-' and is_sudo(msg) then
		if mr_roo[3] == 'plugins' then
		end
		print("disable: "..mr_roo[3])
		return disable_plugin(mr_roo[3], msg)
	end
	
	if mr_roo[2] == '*' and is_sudo(msg) then
		return reload_plugins(true, msg)
	end
end
--######################################################################--
if (mr_roo[1]:lower() == 'reload' ) or (mr_roo[1]:lower() == 'بروز') and is_sudo(msg) then
	return reload_plugins(true, msg)
end
--######################################################################--
end

return {
description = "Plugin to manage other plugins. Enable, disable or reload.",
usage = {
moderator = {
"!pl - [plugin] chat : disable plugin only this chat.",
"!pl + [plugin] chat : enable plugin only this chat.",
},
sudo = {
"!plist : list all plugins.",
"!pl + [plugin] : enable plugin.",
"!pl - [plugin] : disable plugin.",
"!pl * : reloads all plugins." },
},
patterns = {"^[!/#]([Pp]list)$","^[!/#]([Pp]l) (+) ([%w_%.%-]+)$","^[!/#]([Pp]l) (-) ([%w_%.%-]+)$","^[!/#]([Pp]l) (+) ([%w_%.%-]+) (chat)","^[!/#]([Pp]l) (-) ([%w_%.%-]+) (chat)","^[!/#]([Pp]l) (*)$","^[!/#]([Rr]eload)$","^([Pp]list)$","^([Pp]l) (+) ([%w_%.%-]+)$","^([Pp]l) (-) ([%w_%.%-]+)$","^([Pp]l) (+) ([%w_%.%-]+) (chat)","^([Pp]l) (-) ([%w_%.%-]+) (chat)","^([Pp]l) (*)$","^([Rr]eload)$","^(لیست پلاگین)$","^(پلاگین) (+) ([%w_%.%-]+)$","^(پلاگین) (-) ([%w_%.%-]+)$","^(پلاگین) (+) ([%w_%.%-]+) (گروه)","^(پلاگین) (-) ([%w_%.%-]+) (گروه)","^(پلاگین) (*)$","^(بروز)$"},
run = MaTaDoRTeaM,
moderated = true,
privileged = true
}
end