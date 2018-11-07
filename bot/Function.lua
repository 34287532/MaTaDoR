function exi_files(cpath)
	local files = {}
	local pth = cpath
	for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
	end
	return files
end
--######################################################################--
function file_exi(name, cpath)
	for k,v in pairs(exi_files(cpath)) do
		if name == v then
			return true
		end
	end
	return false
end
--######################################################################--
function run_bash(str)
	local cmd = io.popen(str)
	local result = cmd:read('*all')
	return result
end
--######################################################################--
function index_function(user_id)
	for k,v in pairs(_config.admins) do
		if user_id == v[1] then
			print(k)
			return k
		end
	end
	return false
end
--######################################################################--
function getindex(t,id)
	for i,v in pairs(t) do
		if v == id then
			return i
		end
	end
	return nil
end
--######################################################################--
function already_sudo(user_id)
	for k,v in pairs(_config.sudo_users) do
		if user_id == v then
			return k
		end
	end
	return false
end
--######################################################################--
function reload_plugins( )
	plugins = {}
	load_plugins()
end
--######################################################################--
function exi_file()
	local files = {}
	local pth = tcpath..'/files/documents'
	for k, v in pairs(scandir(pth)) do
		if (v:match('.lua$')) then
			table.insert(files, v)
		end
	end
	return files
end
--######################################################################--
function pl_exi(name)
	for k,v in pairs(exi_file()) do
		if name == v then
			return true
		end
	end
	return false
end
--######################################################################--
function sudolist(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local sudo_users = _config.sudo_users
	text = M_START.."*لیست سودو های ربات :*\n"
	for i=1,#sudo_users do
		text = text..i.." - `"..sudo_users[i].."`\n"
	end
	return text
end
--######################################################################--
function adminlist(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local sudo_users = _config.sudo_users
	text = M_START.."*لیست ادمین های ربات :*\n"
	local compare = text
	local i = 1
	for v,user in pairs(_config.admins) do
		text = text..i..'- '..( user[2] or '' )..' ➣ `('..user[1]..')`\n'
		i = i +1
	end
	if compare == text then
		text = M_START..'`ادمینی برای ربات انتخاب نشده`'..EndPm
	end
	return text
end
--######################################################################--
function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
	local groups = 'groups'
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if not data[tostring(groups)] then return end
	local message = M_START..'لیست گروه های ربات ماتادور:\n\n'
	for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
		for m,n in pairsByKeys(settings) do
			local check_time = redis:ttl(RedisIndex..'ExpireDate:'..group_id)
			year = math.floor(check_time / 31536000)
			byear = check_time % 31536000
			month = math.floor(byear / 2592000)
			bmonth = byear % 2592000
			day = math.floor(bmonth / 86400)
			bday = bmonth % 86400
			hours = math.floor( bday / 3600)
			bhours = bday % 3600
			min = math.floor(bhours / 60)
			sec = math.floor(bhours % 60)
			if check_time == -1 then
				remained_expire = 'گروه به صورت نامحدود شارژ میباشد!'
			elseif tonumber(check_time) > 1 and check_time < 60 then
				remained_expire = 'گروه به مدت '..sec..' ثانیه شارژ میباشد'
			elseif tonumber(check_time) > 60 and check_time < 3600 then
				remained_expire = 'گروه به مدت '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
			elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
				remained_expire = 'گروه به مدت '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
			elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
				remained_expire = 'گروه به مدت '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
			elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
				remained_expire = 'گروه به مدت '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
			elseif tonumber(check_time) > 31536000 then
				remained_expire = 'گروه به مدت '..year..' سال '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
			end
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id =  M_START..'نام گروه : '..name..'\n'..M_START..'آیدی : ' ..group_id.. '\n'..M_START..'اعتبار : '..remained_expire..'\n'..M_START..'پنل گروه :\nPanelGp ' ..group_id.. '\n_______________\n'
				group_info = i..' - \n'..group_name_id
				i = i + 1
			end
		end
		message = message..group_info
		local file = io.open("./data/gplist.txt", "w")
		file:write(message)
		file:close()
		MaT = M_START.."لیست گروه های ربات"..EndPm
	end
	tdbot.sendDocument(msg.to.id, "./data/gplist.txt", MaT, nil, msg.id, 0, 1, nil, dl_cb, nil)
end
--######################################################################--
function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
		redis:del(RedisIndex..'CheckExpire::'..msg.to.id)
	end
	if redis:get(RedisIndex..'ExpireDate:'..msg.to.id) then
		redis:del(RedisIndex..'ExpireDate:'..msg.to.id)
	end
	tdbot.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end
--######################################################################--
function warning(msg)
	local expiretime = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if expiretime == -1 then
		return
	else
		local d = math.floor(expiretime / 86400) + 1
		if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
			tdbot.sendMessage(msg.to.id, 0, 1, M_START..'`از شارژ گروه 1 روز باقی مانده\n'..M_START..'برای شارژ مجدد با سودو ربات تماس بگیرید.`\n`سودو ربات :` '..sudo_username..EndPm, 1, 'md')
		end
	end
end
--######################################################################--
function action_by_reply(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if not tonumber(data.sender_user_id) then return false end
	if data.sender_user_id then
		if cmd == "warn" then
			function warn_cb(arg, data)
				msg = arg.msg
				hashwarn = msg.to.id..':warn'
				warnhash = redis:hget(RedisIndex..hashwarn, data.id) or 1
				max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..arg.chat_id) or 5)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم به خودم اخطار دهم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) and not is_admin1(msg.from.id)then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
				end
				if is_admin1(data.id)then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
				end
				if tonumber(warnhash) == tonumber(max_warn) then
					kick_user(data.id, arg.chat_id)
					redis:hdel(RedisIndex..hashwarn, data.id, '0')
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn..""..EndPm, 0, "md")
				else
					redis:hset(RedisIndex..hashwarn, data.id, tonumber(warnhash) + 1)
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"..EndPm, 0, "md")
				end
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, warn_cb, {chat_id=data.chat_id,user_id=data.sender_user_id,msg=arg.msg})
		end
		if cmd == "unwarn" then
			function unwarn_cb(arg, data)
				hashwarn = arg.chat_id..':warn'
				warnhash = redis:hget(RedisIndex..hashwarn, data.id) or 1
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not redis:hget(RedisIndex..hashwarn, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *هیچ اخطاری دریافت نکرده*"..EndPm, 0, "md")
				else
					redis:hdel(RedisIndex..hashwarn, data.id, '0')
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*تمامی اخطار های* `"..data.id.."` - "..user_name.." *پاک شدند*"..EndPm, 0, "md")
				end
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, unwarn_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "setwhitelist" then
			function setwhitelist_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'] then
					administration[tostring(arg.chat_id)]['whitelist'] = {}
					save_data(_config.moderation.data, administration)
				end
				if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به لیست سفید اضافه شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, setwhitelist_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "remwhitelist" then
			function remwhitelist_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'] then
					administration[tostring(arg.chat_id)]['whitelist'] = {}
					save_data(_config.moderation.data, administration)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از لیست سفید حذف شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, remwhitelist_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "setowner" then
			function owner_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل صاحب گروه بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام صاحب گروه منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, owner_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "promote" then
			function promote_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام مدیر گروه منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, promote_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "remowner" then
			function rem_owner_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل صاحب گروه نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام صاحب گروه برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, rem_owner_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "demote" then
			function demote_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام مدیر گروه برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, demote_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "ban" then
			function ban_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*"..EndPm, 0, "md")
				end
				if administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				kick_user(data.id, arg.chat_id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, ban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "unban" then
			function unban_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				channel_unblock(arg.chat_id, data.id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از محرومیت گروه خارج شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, unban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "silent" then
			function silent_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndPm, 0, "md")
				end
				if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل توانایی چت کردن رو نداشت*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *توانایی چت کردن رو از دست داد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, silent_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "unsilent" then
			function unsilent_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل توانایی چت کردن را داشت*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *توانایی چت کردن رو به دست آورد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, unsilent_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "banall" then
			function gban_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration['gban_users'] then
					administration['gban_users'] = {}
					save_data(_config.moderation.data, administration)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndPm, 0, "md")
				end
				if is_admin1(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*"..EndPm, 0, "md")
				end
				if is_gbanned(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه های ربات محروم بود*"..EndPm, 0, "md")
				end
				administration['gban_users'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				kick_user(data.id, arg.chat_id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از تمام گروه های ربات محروم شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, gban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "unbanall" then
			function ungban_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration['gban_users'] then
					administration['gban_users'] = {}
					save_data(_config.moderation.data, administration)
				end
				if not is_gbanned(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه های ربات محروم نبود*"..EndPm, 0, "md")
				end
				administration['gban_users'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از محرومیت گروه های ربات خارج شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, ungban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
		end
		if cmd == "kick" then
			if data.sender_user_id == our_id then
				return tdbot.sendMessage(data.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از گروه اخراج کنم کنم*"..EndPm, 0, "md")
			elseif is_mod1(data.chat_id, data.sender_user_id) then
				return tdbot.sendMessage(data.chat_id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndPm, 0, "md")
			else
				kick_user(data.sender_user_id, data.chat_id)
				sleep(1)
				channel_unblock(data.chat_id, data.sender_user_id)
			end
		end
		if cmd == "delall" then
			if is_mod1(data.chat_id, data.sender_user_id) then
				return tdbot.sendMessage(data.chat_id, "", 0, M_START.."*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*"..EndPm, 0, "md")
			else
				tdbot.deleteMessagesFromUser(data.chat_id, data.sender_user_id, dl_cb, nil)
				tdbot.sendMention(data.chat_id,data.sender_user_id, data.id,M_START..'تمام پیام های '..data.sender_user_id..' پاک شد'..EndPm,16,string.len(data.sender_user_id))
			end
		end
		if cmd == "adminprom" then
			function adminprom_cb(arg, data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if is_admin1(tonumber(data.id)) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات بود*"..EndPm, 0, "md")
				end
				table.insert(_config.admins, {tonumber(data.id), user_name})
				save_config()
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام ادمین ربات منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, adminprom_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "admindem" then
			function admindem_cb(arg, data)
				local nameid = index_function(tonumber(data.id))
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not is_admin1(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات نبود*"..EndPm, 0, "md")
				end
				table.remove(_config.admins, nameid)
				save_config()
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام ادمین ربات برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, admindem_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "visudo" then
			function visudo_cb(arg, data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if already_sudo(tonumber(data.id)) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات بود*"..EndPm, 0, "md")
				end
				table.insert(_config.sudo_users, tonumber(data.id))
				save_config()
				reload_plugins(true)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام سودو ربات منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, visudo_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
		if cmd == "desudo" then
			function desudo_cb(arg, data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not already_sudo(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات نبود*"..EndPm, 0, "md")
				end
				table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id)))
				save_config()
				reload_plugins(true)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام سودو ربات برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, desudo_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
	end
end
--######################################################################--
function action_by_username(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if not arg.username then return false end
	if data.id then
		if cmd == "warn" then
			function warn_cb(arg, data)
				if not data.id then return end
				msg = arg.msg
				hashwarn = msg.to.id..':warn'
				warnhash = redis:hget(RedisIndex..hashwarn, data.id) or 1
				max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..arg.chat_id) or 5)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم به خودم اخطار دهم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) and not is_admin1(msg.from.id)then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
				end
				if is_admin1(data.id)then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
				end
				if tonumber(warnhash) == tonumber(max_warn) then
					kick_user(data.id, arg.chat_id)
					redis:hdel(RedisIndex..hashwarn, data.id, '0')
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn..""..EndPm, 0, "md")
				else
					redis:hset(RedisIndex..hashwarn, data.id, tonumber(warnhash) + 1)
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"..EndPm, 0, "md")
				end
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, warn_cb, {chat_id=arg.chat_id,user_id=data.id,msg=arg.msg})
		end
		if cmd == "unwarn" then
			if not data.id then return end
			function unwarn_cb(arg, data)
				hashwarn = arg.chat_id..':warn'
				warnhash = redis:hget(RedisIndex..hashwarn, data.id) or 1
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not redis:hget(RedisIndex..hashwarn, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *هیچ اخطاری دریافت نکرده*", 0, "md")
				else
					redis:hdel(RedisIndex..hashwarn, data.id, '0')
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*تمامی اخطار های* `"..data.id.."` - "..user_name.." *پاک شدند*"..EndPm, 0, "md")
				end
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, unwarn_cb, {chat_id=arg.chat_id,user_id=data.id,msg=arg.msg})
		end
		if cmd == "setwhitelist" then
			function setwhitelist_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'] then
					administration[tostring(arg.chat_id)]['whitelist'] = {}
					save_data(_config.moderation.data, administration)
				end
				if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به لیست سفید اضافه شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, setwhitelist_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "remwhitelist" then
			function remwhitelist_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'] then
					administration[tostring(arg.chat_id)]['whitelist'] = {}
					save_data(_config.moderation.data, administration)
				end
				if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از لیست سفید حذف شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, remwhitelist_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "setowner" then
			function owner_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل صاحب گروه بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام صاحب گروه منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, owner_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "promote" then
			function promote_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام مدیر گروه منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, promote_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "remowner" then
			function rem_owner_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.."*از قبل صاحب گروه نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام صاحب گروه برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, rem_owner_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "demote" then
			function demote_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if not data.id then return end
				if data.username and data.username ~= "" then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام مدیر گروه برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, demote_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "res" then
			function res_cb(arg, data)
				if not data.id then return end
				if data.last_name then
					user_name = check_markdown(data.first_name).." "..check_markdown(data.last_name)
				else
					user_name = check_markdown(data.first_name)
				end
				text = M_START.."`اطلاعات برای :` @"..check_markdown(data.username).."\n"..M_START.."`نام :` "..user_name.."\n"..M_START.."`ایدی :` *"..data.id.."*"
				return tdbot.sendMessage(arg.chat_id, "", 0, text, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, res_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "ban" then
			function ban_cb(arg, data)
				if not data.id then return end
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*"..EndPm, 0, "md")
				end
				if administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." * از گروه محروم بود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				kick_user(data.id, arg.chat_id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, ban_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "unban" then
			function unban_cb(arg, data)
				if not data.id then return end
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم نبود*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				channel_unblock(arg.chat_id, data.id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از محرومیت گروه خارج شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, unban_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "silent" then
			function silent_cb(arg, data)
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndPm, 0, "md")
				end
				if is_mod1(arg.chat_id, data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndPm, 0, "md")
				end
				if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل توانایی چت کردن رو نداشت*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *توانایی چت کردن رو از دست داد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, silent_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "unsilent" then
			function unsilent_cb(arg, data)
				if not data.id then return end
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل توانایی چت کردن را داشت*"..EndPm, 0, "md")
				end
				administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *توانایی چت کردن رو به دست آورد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, unsilent_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "banall" then
			function gban_cb(arg, data)
				if not data.id then return end
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration['gban_users'] then
					administration['gban_users'] = {}
					save_data(_config.moderation.data, administration)
				end
				if data.id == our_id then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndPm, 0, "md")
				end
				if is_admin1(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*"..EndPm, 0, "md")
				end
				if is_gbanned(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه های ربات محروم بود*"..EndPm, 0, "md")
				end
				administration['gban_users'][tostring(data.id)] = user_name
				save_data(_config.moderation.data, administration)
				kick_user(data.id, arg.chat_id)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از تمام گروه های ربات محروم شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, gban_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "unbanall" then
			function ungban_cb(arg, data)
				if not data.id then return end
				local administration = load_data(_config.moderation.data)
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not administration['gban_users'] then
					administration['gban_users'] = {}
					save_data(_config.moderation.data, administration)
				end
				if not is_gbanned(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه های ربات محروم نبود*"..EndPm, 0, "md")
				end
				administration['gban_users'][tostring(data.id)] = nil
				save_data(_config.moderation.data, administration)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از محرومیت گروه های ربات خارج شد*"..EndPm, 0, "md")
			end
			assert(tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, ungban_cb, {chat_id=arg.chat_id,user_id=data.id}))
		end
		if cmd == "kick" then
			if not data.id then return end
			if data.id == our_id then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم خودم رو از گروه اخراج کنم کنم*"..EndPm, 0, "md")
			elseif is_mod1(arg.chat_id, data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndPm, 0, "md")
			else
				kick_user(data.id, arg.chat_id)
				sleep(1)
				channel_unblock(arg.chat_id, data.id)
			end
		end
		if cmd == "delall" then
			if not data.id then return end
			if is_mod1(arg.chat_id, data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*"..EndPm, 0, "md")
			else
				tdbot.deleteMessagesFromUser(arg.chat_id, data.id, dl_cb, nil)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*تمام پیام های* "..data.title.." *[ "..data.id.." ]* *پاک شد*"..EndPm, 0, "md")
			end
		end
		if cmd == "adminprom" then
			function adminprom_cb(arg, data)
				if not data.id then return end
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if is_admin1(tonumber(data.id)) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات بود*"..EndPm, 0, "md")
				end
				table.insert(_config.admins, {tonumber(data.id), user_name})
				save_config()
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام ادمین ربات منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, adminprom_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "admindem" then
			function admindem_cb(arg, data)
				if not data.id then return end
				local nameid = index_function(tonumber(data.id))
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not is_admin1(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات نبود*"..EndPm, 0, "md")
				end
				table.remove(_config.admins, nameid)
				save_config()
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام ادمین ربات برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, admindem_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "visudo" then
			function visudo_cb(arg, data)
				if not data.id then return end
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if already_sudo(tonumber(data.id)) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات بود*"..EndPm, 0, "md")
				end
				table.insert(_config.sudo_users, tonumber(data.id))
				save_config()
				reload_plugins(true)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام سودو ربات منتصب شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, visudo_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
		if cmd == "desudo" then
			function desudo_cb(arg, data)
				if not data.id then return end
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if not already_sudo(data.id) then
					return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات نبود*"..EndPm, 0, "md")
				end
				table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id)))
				save_config()
				reload_plugins(true)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام سودو ربات برکنار شد*"..EndPm, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, desudo_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
	end
end
--######################################################################--
function action_by_id(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if not tonumber(arg.user_id) then return false end
	if data.id then
		if data.username then
			user_name = '@'..check_markdown(data.username)
		else
			user_name = check_markdown(data.first_name)
		end
		if cmd == "warn" then
			if data.id == our_id then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*من نمیتوانم به خودم اخطار دهم*"..EndPm, 0, "md")
			end
			if is_mod1(arg.chat_id, data.id) and not is_admin1(msg.from.id)then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
			end
			if is_admin1(data.id)then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndPm, 0, "md")
			end
			if tonumber(warnhash) == tonumber(max_warn) then
				kick_user(data.id, arg.chat_id)
				redis:hdel(RedisIndex..hashwarn, data.id, '0')
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..hashwarn.."/"..max_warn..""..EndPm, 0, "md")
			else
				redis:hset(RedisIndex..hashwarn, data.id, tonumber(warnhash) + 1)
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"..EndPm, 0, "md")
			end
		end
		if cmd == "unwarn" then
			if not redis:hget(RedisIndex..hashwarn, data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *هیچ اخطاری دریافت نکرده*"..EndPm, 0, "md")
			else
				redis:hdel(RedisIndex..hashwarn, data.id, '0')
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*تمامی اخطار های* `"..data.id.."` - "..user_name.." *پاک شدند*"..EndPm, 0, "md")
			end
		end
		if cmd == "setwhitelist" then
			if not administration[tostring(arg.chat_id)]['whitelist'] then
				administration[tostring(arg.chat_id)]['whitelist'] = {}
				save_data(_config.moderation.data, administration)
			end
			if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید بود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = user_name
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به لیست سفید اضافه شد*"..EndPm, 0, "md")
		end
		if cmd == "remwhitelist" then
			if not administration[tostring(arg.chat_id)]['whitelist'] then
				administration[tostring(arg.chat_id)]['whitelist'] = {}
				save_data(_config.moderation.data, administration)
			end
			if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست سفید نبود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id)] = nil
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از لیست سفید حذف شد*"..EndPm, 0, "md")
		end
		if cmd == "setowner" then
			if administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل صاحب گروه بود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = user_name
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام صاحب گروه منتصب شد*"..EndPm, 0, "md")
		end
		if cmd == "promote" then
			if administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه بود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = user_name
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام مدیر گروه منتصب شد*"..EndPm, 0, "md")
		end
		if cmd == "remowner" then
			if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.."*از قبل صاحب گروه نبود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['owners'][tostring(data.id)] = nil
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام صاحب گروه برکنار شد*"..EndPm, 0, "md")
		end
		if cmd == "demote" then
			if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه نبود*"..EndPm, 0, "md")
			end
			administration[tostring(arg.chat_id)]['mods'][tostring(data.id)] = nil
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام مدیر گروه برکنار شد*"..EndPm, 0, "md")
		end
		if cmd == "whois" then
			if data.username then
				username = '@'..check_markdown(data.username)
			else
				username = 'ندارد'
			end
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START..'اطلاعات برای [ '..data.id..' ] :\n'..M_START..'یوزرنیم : '..username..'\n'..M_START..'نام : '..check_markdown(data.first_name), 0, "md")
		end
		if cmd == "adminprom" then
			if is_admin1(tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات بود*"..EndPm, 0, "md")
			end
			table.insert(_config.admins, {tonumber(data.id), user_name})
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام ادمین ربات منتصب شد*"..EndPm, 0, "md")
		end
		if cmd == "admindem" then
			local nameid = index_function(tonumber(data.id))
			if not is_admin1(data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات نبود*"..EndPm, 0, "md")
			end
			table.remove(_config.admins, nameid)
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام ادمین ربات برکنار شد*"..EndPm, 0, "md")
		end
		if cmd == "visudo" then
			if already_sudo(tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات بود*"..EndPm, 0, "md")
			end
			table.insert(_config.sudo_users, tonumber(data.id))
			save_config()
			reload_plugins(true)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام سودو ربات منتصب شد*"..EndPm, 0, "md")
		end
		if cmd == "desudo" then
			if not already_sudo(data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات نبود*"..EndPm, 0, "md")
			end
			table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id)))
			save_config()
			reload_plugins(true)
			return tdbot.sendMessage(arg.chat_id, "", 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام سودو ربات برکنار شد*"..EndPm, 0, "md")
		end
	end
end
--######################################################################--
function pre_processTools(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if msg.to.type ~= 'pv' then
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get(RedisIndex..'CheckExpire::'..msg.to.id)
		local exd = redis:get(RedisIndex..'ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
			redis:set(RedisIndex..'ExpireDate:'..msg.to.id,true)
			redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, 86400, true)
			tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*گروه به مدت 1 روز شارژ شد. لطفا با سودو برای شارژ بیشتر تماس بگیرید.*\n`سودو ربات :` '..sudo_username..EndPm, 1, 'md')
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = M_START..'شارژ این گروه به اتمام رسید \n\nID:  <code>'..msg.to.id..'</code>\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave '..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/jointo '..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<b>برای شارژ 1 ماهه:</b>\n/plan 1 '..msg.to.id..'\n\n<b>برای شارژ 3 ماهه:</b>\n/plan 2 '..msg.to.id..'\n\n<b>برای شارژ نامحدود:</b>\n/plan 3 '..msg.to.id
			local text2 = M_START..'*شارژ این گروه به پایان رسید. به دلیل عدم شارژ مجدد، گروه از لیست ربات حذف و ربات از گروه خارج میشود.*\n`سودو ربات :`'..sudo_username..EndPm
			tdbot.sendMessage(gp_sudo, 0, 1, text1, 1, 'html')
			tdbot.sendMessage(msg.to.id, 0, 1, text2, 1, 'md')
			botrem(msg)
		else
			local expiretime = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
	if msg.to.type == 'channel' and msg.content.text and redis:hget(RedisIndex.."CodeGiftt:", msg.content.text) then
		local b = redis:ttl(RedisIndex.."CodeGiftCharge:"..msg.content.text)
		local expire = math.floor(b / 86400 ) + 1
		local c = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
		local extime = math.floor(c / 86400 ) + 1
		redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, tonumber(extime * 86400) + tonumber(expire * 86400), true)
		redis:del(RedisIndex.."Codegift:"..msg.to.id)
		redis:srem(RedisIndex.."CodeGift:" , msg.content.text)
		redis:hdel(RedisIndex.."CodeGiftt:", msg.content.text)
		local expire_date = ''
		local expi = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
		if expi == -1 then
			expire_date = 'نامحدود!'
		else
			local day = math.floor(expi / 86400) + 1
			expire_date = day..' روز'
		end
		local text = M_START.."`کدهدیه :`\n"..msg.content.text.."\n`استفاده شد توسط :`\n*مشخصات کاربر :*\n`꧁` @"..check_markdown(msg.from.username or '').." | "..check_markdown(msg.from.first_name).." `꧂`\n*ایدی گروه :*\n"..msg.chat_id.."\n*میزان شارژ هدیه :* `"..expire.."` *روز\nشارژ جدید گروه کاربر :* `"..expire_date.."`"
		tdbot.sendMessage(gp_sudo, msg.id, 1, text, 1, 'md')
		local text2 = M_START..'`انجام شد !`\n`به گروه شما` *'..expire..'* `روز شارژ هدیه اضافه شد`'..EndPm
		tdbot.sendMessage(msg.chat_id, msg.id, 1, text2, 1, 'md')
	end
end
--######################################################################--
function pre_processAuto(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex.."atolct2"..msg.to.id) or redis:get(RedisIndex.."atolct2"..msg.to.id) then
		local time = os.date("%H%M")
		local time2 = redis:get(RedisIndex.."atolct1"..msg.to.id)
		time2 = time2.gsub(time2,":","")
		local time3 = redis:get(RedisIndex.."atolct2"..msg.to.id)
		time3 = time3.gsub(time3,":","")
		if tonumber(time3) < tonumber(time2) then
			if tonumber(time) <= 2359 and tonumber(time) >= tonumber(time2) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
					tdbot.sendMessage(msg.to.id, 0, 1, M_START..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndPm, 1, 'md')
				end
			elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(time3) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					tdbot.sendMessage(msg.to.id, 0, 1, M_START..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndPm, 1, 'md')
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
				end
			else
				if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:del(RedisIndex.."lc_ato:"..msg.to.id, true)
				end
			end
		elseif tonumber(time3) > tonumber(time2) then
			if tonumber(time) >= tonumber(time2) and tonumber(time) < tonumber(time3) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					tdbot.sendMessage(msg.to.id, 0, 1, M_START..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndPm, 1, 'md')
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
				end
			else
				if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:del(RedisIndex.."lc_ato:"..msg.to.id, true)
				end
			end
		end
	end
	local is_channel = msg.to.type == "channel"
	local is_chat = msg.to.type == "chat"
	if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
		if not is_mod(msg) then
			if is_channel then
				del_msg(msg.to.id, tonumber(msg.id))
			elseif is_chat then
				kick_user(msg.sender_user_id, msg.to.id)
			end
		end
	end
end
--######################################################################--
function pre_processBan(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if msg.to.type ~= 'pv' then
		chat = msg.to.id
		user = msg.from.id
		function check_newmember(arg, data)
			test = load_data(_config.moderation.data)
			if test[arg.chat_id] then
				if test[arg.chat_id]['settings'] then
					lock_bots = redis:get(RedisIndex..'lock_bots:'..msg.chat_id)
				end
			end
			if data.type._ == "userTypeBot" then
				if not is_owner(arg.msg) and lock_bots == 'Enable' then
					kick_user(data.id, arg.chat_id)
				end
			end
			if data.username then
				user_name = '@'..check_markdown(data.username)
			else
				user_name = check_markdown(data.first_name)
			end
			if is_banned(data.id, arg.chat_id) then
				tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه محروم است*"..EndPm, 0, "md")
				kick_user(data.id, arg.chat_id)
			end
			if is_gbanned(data.id) then
				tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, M_START.."*کاربر* `"..data.id.."` - "..user_name.." *از تمام گروه های ربات محروم است*"..EndPm, 0, "md")
				kick_user(data.id, arg.chat_id)
			end
		end
		if msg.adduser then
			assert(tdbot_function ({
			_ = "getUser",
			user_id = msg.adduser
			}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg}))
		end
		if msg.joinuser then
			assert(tdbot_function ({
			_ = "getUser",
			user_id = msg.joinuser
			}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg}))
		end
	end
	-- return msg
end
--######################################################################--
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
--######################################################################--
function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
--######################################################################--
function opizoLink(Url)
	local Opizo = http.request('http://enigma-dev.ir/api/opizo/?url='..URL.escape(Url))
	if Opizo then
		if json:decode(Opizo) then
			OpizoJ = json:decode(Opizo)
			return OpizoJ.result or OpizoJ.description
		end
	end
end
--######################################################################--
function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	if not types[1] then return end
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then
		zoom=4
	else
		zoom = 13
	end
	local parameters =
	"size=600x300" ..
	"&zoom="  .. zoom ..
	"&center=" .. URL.escape(area) ..
	"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
--######################################################################--
function get_weather(location)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
	local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________'
	local conditions = 'شرایط فعلی آب و هوا : '
	if weather.weather[1].main == 'Clear' then
		conditions = conditions .. 'آفتابی☀'
	elseif weather.weather[1].main == 'Clouds' then
		conditions = conditions .. 'ابری ☁☁'
	elseif weather.weather[1].main == 'Rain' then
		conditions = conditions .. 'بارانی ☔'
	elseif weather.weather[1].main == 'Thunderstorm' then
		conditions = conditions .. 'طوفانی ☔☔☔☔'
	elseif weather.weather[1].main == 'Mist' then
		conditions = conditions .. 'مه 💨'
	end
	return temp .. '\n' .. conditions
end
--######################################################################--
function calc(exp)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
		text = 'Result = '..b..'\n____________________'..channel_username
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return text
end
--######################################################################--
function exi_filef(path, suffix)
	local files = {}
	local pth = tostring(path)
	local psv = tostring(suffix)
	for k, v in pairs(scandir(pth)) do
		if (v:match('.'..psv..'$')) then
			table.insert(files, v)
		end
	end
	return files
end
--######################################################################--
function file_exif(name, path, suffix)
	local fname = tostring(name)
	local pth = tostring(path)
	local psv = tostring(suffix)
	for k,v in pairs(exi_filef(pth, psv)) do
		if fname == v then
			return true
		end
	end
	return false
end
--######################################################################--
function getRandomButts(attempt)
	attempt = attempt or 0
	attempt = attempt + 1
	local res,status = http.request("http://api.obutts.ru/noise/1")
	if status ~= 200 then return nil end
	local data = json:decode(res)[1]
	if not data and attempt <= 3 then
		return getRandomButts(attempt)
	end
	return 'http://media.obutts.ru/' .. data.preview
end
--######################################################################--
function getRandomBoobs(attempt)
	attempt = attempt or 0
	attempt = attempt + 1
	local res,status = http.request("http://api.oboobs.ru/noise/1")
	if status ~= 200 then return nil end
	local data = json:decode(res)[1]
	if not data and attempt < 10 then
		return getRandomBoobs(attempt)
	end
	return 'http://media.oboobs.ru/' .. data.preview
end
--######################################################################--
function modadd(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if not is_admin(msg) then
		return M_START..'`شما مدیر` #ربات `نمیباشید`'..EndPm
	end
	local data = load_data(_config.moderation.data)
	if data[tostring(msg.to.id)] then
		return M_START..'`ربات در` #لیست `گروه ربات از قبل بود`'..EndPm
	end
	-- create data array in moderation.json
	data[tostring(msg.to.id)] = {
	owners = {},
	mods ={},
	banned ={},
	is_silent_users ={},
	filterlist ={},
	whitelist ={},
	settings = {
	set_name = msg.to.title,
	num_msg_max = '5',
	set_char = '40',
	time_check = '2',
	},
	}
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = {}
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
	save_data(_config.moderation.data, data)
	return M_START..'`گروه به` #لیست `گروه ربات اضافه شده` ✅🤖\n\n*اسم گروه :*'..check_markdown(msg.to.title)..'\n*توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'..EndPm
end
--######################################################################--
function modrem(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if not is_admin(msg) then
		return M_START..'`شما مدیر` #ربات `نمیباشید`'..EndPm
	end
	local data = load_data(_config.moderation.data)
	local receiver = msg.to.id
	if not data[tostring(msg.to.id)] then
		return M_START..'`گروه در` #لیست `گروه ربات  نیست`'..EndPm
	end
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
		end data[tostring(groups)][tostring(msg.to.id)] = nil
		save_data(_config.moderation.data, data)
		return M_START..'`گروه از` #لیست `گروه های ربات حدف شد` ❌🤖\n\n*اسم گروه :*'..msg.to.title..'\n*توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'..EndPm
	end
--######################################################################--
function filter_word(msg, word)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local data = load_data(_config.moderation.data)
	if not data[tostring(msg.to.id)]['filterlist'] then
		data[tostring(msg.to.id)]['filterlist'] = {}
		save_data(_config.moderation.data, data)
	end
	if data[tostring(msg.to.id)]['filterlist'][(word)] then
		return M_START.."`کلمه` *"..word.."* `از قبل فیلتر بود`"..EndPm
	end
	data[tostring(msg.to.id)]['filterlist'][(word)] = true
	save_data(_config.moderation.data, data)
	return M_START.."`کلمه` *"..word.."* `به لیست کلمات فیلتر شده اضافه شد`"..EndPm
end
--######################################################################--
function unfilter_word(msg, word)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local data = load_data(_config.moderation.data)
	if not data[tostring(msg.to.id)]['filterlist'] then
		data[tostring(msg.to.id)]['filterlist'] = {}
		save_data(_config.moderation.data, data)
	end
	if data[tostring(msg.to.id)]['filterlist'][word] then
		data[tostring(msg.to.id)]['filterlist'][(word)] = nil
		save_data(_config.moderation.data, data)
		return M_START.."`کلمه` *"..word.."* `از لیست کلمات فیلتر شده حذف شد`"..EndPm
	else
		return M_START.."`کلمه` *"..word.."* `از قبل فیلتر نبود`"..EndPm
	end
end
--######################################################################--
function group_settings(msg, target)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if not is_mod(msg) then
		return M_START.."`شما` #مدیر `گروه نیستید`"..EndPm
	end
	local data = load_data(_config.moderation.data)
	local target = msg.to.id
	if data[tostring(target)] then
		if data[tostring(target)]["settings"]["num_msg_max"] then
			NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
			print('custom'..NUM_MSG_MAX)
		else
			NUM_MSG_MAX = 5
		end
		if data[tostring(target)]["settings"]["set_char"] then
			SETCHAR = tonumber(data[tostring(target)]['settings']['set_char'])
			print('custom'..SETCHAR)
		else
			SETCHAR = 40
		end
		if data[tostring(target)]["settings"]["time_check"] then
			TIME_CHECK = tonumber(data[tostring(target)]['settings']['time_check'])
			print('custom'..TIME_CHECK)
		else
			TIME_CHECK = 2
		end
	end
	lock_link = redis:get(RedisIndex..'lock_link:'..msg.chat_id)
	lock_join = redis:get(RedisIndex..'lock_join:'..msg.chat_id)
	lock_tag = redis:get(RedisIndex..'lock_tag:'..msg.chat_id)
	lock_username = redis:get(RedisIndex..'lock_username:'..msg.chat_id)
	lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
	lock_arabic = redis:get(RedisIndex..'lock_arabic:'..msg.chat_id)
	lock_mention = redis:get(RedisIndex..'lock_mention:'..msg.chat_id)
	lock_edit = redis:get(RedisIndex..'lock_edit:'..msg.chat_id)
	lock_spam = redis:get(RedisIndex..'lock_spam:'..msg.chat_id)
	lock_flood = redis:get(RedisIndex..'lock_flood:'..msg.chat_id)
	lock_markdown = redis:get(RedisIndex..'lock_markdown:'..msg.chat_id)
	lock_webpage = redis:get(RedisIndex..'lock_webpage:'..msg.chat_id)
	lock_welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
	lock_views = redis:get(RedisIndex..'views:'..msg.chat_id)
	lock_bots = redis:get(RedisIndex..'lock_bots:'..msg.chat_id)
	mute_all = redis:get(RedisIndex..'mute_all:'..msg.chat_id)
	mute_gif = redis:get(RedisIndex..'mute_gif:'..msg.chat_id)
	mute_photo = redis:get(RedisIndex..'mute_photo:'..msg.chat_id)
	mute_sticker = redis:get(RedisIndex..'mute_sticker:'..msg.chat_id)
	mute_contact = redis:get(RedisIndex..'mute_contact:'..msg.chat_id)
	mute_inline = redis:get(RedisIndex..'mute_inline:'..msg.chat_id)
	mute_game = redis:get(RedisIndex..'mute_game:'..msg.chat_id)
	mute_text = redis:get(RedisIndex..'mute_text:'..msg.chat_id)
	mute_keyboard = redis:get(RedisIndex..'mute_keyboard:'..msg.chat_id)
	mute_forward = redis:get(RedisIndex..'mute_forward:'..msg.chat_id)
	mute_location = redis:get(RedisIndex..'mute_location:'..msg.chat_id)
	mute_document = redis:get(RedisIndex..'mute_document:'..msg.chat_id)
	mute_voice = redis:get(RedisIndex..'mute_voice:'..msg.chat_id)
	mute_audio = redis:get(RedisIndex..'mute_audio:'..msg.chat_id)
	mute_video = redis:get(RedisIndex..'mute_video:'..msg.chat_id)
	mute_video_note = redis:get(RedisIndex..'mute_video_note:'..msg.chat_id)
	mute_tgservice = redis:get(RedisIndex..'mute_tgservice:'..msg.chat_id)
	local gif = (mute_gif == "Warn") and "اخطار" or ((mute_gif == "Kick") and "اخراج" or ((mute_gif == "Mute") and "سکوت" or ((mute_gif == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local photo = (mute_photo == "Warn") and "اخطار" or ((mute_photo == "Kick") and "اخراج" or ((mute_photo == "Mute") and "سکوت" or ((mute_photo == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local sticker = (mute_sticker == "Warn") and "اخطار" or ((mute_sticker == "Kick") and "اخراج" or ((mute_sticker == "Mute") and "سکوت" or ((mute_sticker == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local contact = (mute_contact == "Warn") and "اخطار" or ((mute_contact == "Kick") and "اخراج" or ((mute_contact == "Mute") and "سکوت" or ((mute_contact == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local inline = (mute_inline == "Warn") and "اخطار" or ((mute_inline == "Kick") and "اخراج" or ((mute_inline == "Mute") and "سکوت" or ((mute_inline == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local game = (mute_game == "Warn") and "اخطار" or ((mute_game == "Kick") and "اخراج" or ((mute_game == "Mute") and "سکوت" or ((mute_game == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local text = (mute_text == "Warn") and "اخطار" or ((mute_text == "Kick") and "اخراج" or ((mute_text == "Mute") and "سکوت" or ((mute_text == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local keyboard = (mute_keyboard == "Warn") and "اخطار" or ((mute_keyboard == "Kick") and "اخراج" or ((mute_keyboard == "Mute") and "سکوت" or ((mute_keyboard == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local forward = (mute_forward == "Warn") and "اخطار" or ((mute_forward == "Kick") and "اخراج" or ((mute_forward == "Mute") and "سکوت" or ((mute_forward == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local views = (lock_views == "Warn") and "اخطار" or ((lock_views == "Kick") and "اخراج" or ((lock_views == "Mute") and "سکوت" or ((lock_views == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local location = (mute_location == "Warn") and "اخطار" or ((mute_location == "Kick") and "اخراج" or ((mute_location == "Mute") and "سکوت" or ((mute_location == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local document = (mute_document == "Warn") and "اخطار" or ((mute_document == "Kick") and "اخراج" or ((mute_document == "Mute") and "سکوت" or ((mute_document == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local voice = (mute_voice == "Warn") and "اخطار" or ((mute_voice == "Kick") and "اخراج" or ((mute_voice == "Mute") and "سکوت" or ((mute_voice == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local audio = (mute_audio == "Warn") and "اخطار" or ((mute_audio == "Kick") and "اخراج" or ((mute_audio == "Mute") and "سکوت" or ((mute_audio == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local video = (mute_video == "Warn") and "اخطار" or ((mute_video == "Kick") and "اخراج" or ((mute_video == "Mute") and "سکوت" or ((mute_video == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local video_note = (mute_video_note == "Warn") and "اخطار" or ((mute_video_note == "Kick") and "اخراج" or ((mute_video_note == "Mute") and "سکوت" or ((mute_video_note == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local link = (lock_link == "Warn") and "اخطار" or ((lock_link == "Kick") and "اخراج" or ((lock_link == "Mute") and "سکوت" or ((lock_link == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local tag = (lock_tag == "Warn") and "اخطار" or ((lock_tag == "Kick") and "اخراج" or ((lock_tag == "Mute") and "سکوت" or ((lock_tag == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local username = (lock_username == "Warn") and "اخطار" or ((lock_username == "Kick") and "اخراج" or ((lock_username == "Mute") and "سکوت" or ((lock_username == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local arabic = (lock_arabic == "Warn") and "اخطار" or ((lock_arabic == "Kick") and "اخراج" or ((lock_arabic == "Mute") and "سکوت" or ((lock_arabic == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local mention = (lock_mention == "Warn") and "اخطار" or ((lock_mention == "Kick") and "اخراج" or ((lock_mention == "Mute") and "سکوت" or ((lock_mention == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local edit = (lock_edit == "Warn") and "اخطار" or ((lock_edit == "Kick") and "اخراج" or ((lock_edit == "Mute") and "سکوت" or ((lock_edit == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local markdown = (lock_markdown == "Warn") and "اخطار" or ((lock_markdown == "Kick") and "اخراج" or ((lock_markdown == "Mute") and "سکوت" or ((lock_markdown == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local webpage = (lock_webpage == "Warn") and "اخطار" or ((lock_webpage == "Kick") and "اخراج" or ((lock_webpage == "Mute") and "سکوت" or ((lock_webpage == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local bots =  (lock_bots == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local all =  (mute_all == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local tgservice =  (mute_tgservice == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local join =  (lock_join == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local pin =  (lock_pin == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local spam =  (lock_spam == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local flood =  (lock_flood == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local welcome = (lock_welcome == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local expire_date = ''
	local expi = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
	if expi == -1 then
		expire_date = 'نامحدود!'
	else
		local day = math.floor(expi / 86400) + 1
		expire_date = day..' روز'
	end
	local t1 = redis:get(RedisIndex.."atolct1"..msg.chat_id)
	local t2 = redis:get(RedisIndex.."atolct2"..msg.chat_id)
	if t1 and t2 then
		stats1 = ''..t1..' && '..t2..''
	else
		stats1 = '`تنظیم نشده`'
	end
	text = "*••• تنظیمات گروه :*\n\n`🔐 تنظیمات قفل پیشرفته گروه ;`\n\n*ویرایش :* `"..edit.."`\n*لینک :* `"..link.."`\n*ویو :* `"..views.."`\n*تگ(#) :* `"..tag.."`\n*نام کاربری(@) :* `"..username.."`\n*منشن :* `"..mention.."`\n*فارسی :* `"..arabic.."`\n*وبسایت :* `"..webpage.."`\n*فونت :* `"..markdown.."`\n*گیف :* `"..gif.."`\n*متن :* `"..text.."`\n*دکمه شیشه ای :* `"..inline.."`\n*بازی :* `"..game.."`\n*عکس :* `"..photo.."`\n*فیلم :* `"..video.."`\n*اهنگ :* `"..audio.."`\n*ویس :* `"..voice.."`\n*استیکر :* `"..sticker.."`\n*مخاطب :* `"..contact.."`\n*فوروارد :* `"..forward.."`\n*موقعیت مکانی :* `"..location.."`\n*فایل :* `"..document.."`\n*کیبورد  via :* `"..keyboard.."`\n*فیلم سلفی :* `"..video_note.."`\n➿〰➿〰➿〰➿〰\n`🔐 تتظیمات قفل معمولی گروه ;`\n\n*قفل گروه :* `"..all.."`\n*سرویس تلگرام  :* `"..tgservice.."`\n*ورود :* `"..join.."`\n*پیام مکرر :* `"..flood.."`\n*هرزنامه :* `"..spam.."`\n➿〰➿〰➿〰➿〰\n`♨️ تنظیمات بیشتر گروه ;`\n\n*خوشآمد :* `"..welcome.."`\n*سنجاق پیام :* `"..pin.."`\n*قفل ربات :* `"..bots.."`\n*حداکثر پیام مکرر :* `"..NUM_MSG_MAX.."`\n*حداکثر کارکتر :* `"..SETCHAR.."`\n*زمان برسی پیام مکرر :* `"..TIME_CHECK.."`\n*قفل خودکار :* "..stats1.."\n➿〰➿〰➿〰➿〰\n`🌐 اطلاعات ;`\n\n*نام گروه :* "..check_markdown(msg.to.title).."\n*آیدی گروه :* `"..msg.to.id.."`\n*نام شما :* "..check_markdown(msg.from.first_name).."\n*آیدی شما :* `"..msg.from.id.."`\n*نام کاربری شما :* @"..check_markdown(msg.from.username or "").."\n➿〰➿〰➿〰➿〰\n*تاریخ انقضا :* `"..expire_date.."`\n*کانال  :* "..check_markdown(channel_username).."\n*سازنده ربات :* "..check_markdown(sudo_username)..""
	text = string.gsub(text, 'MaTaDoRUnlock', M_START.."غیرفعال")
	text = string.gsub(text, 'MaTaDoRLock', M_START.."فعال")
	text = string.gsub(text, 'اخطار', M_START.."اخطار")
	text = string.gsub(text, 'اخراج', M_START.."اخراج")
	text = string.gsub(text, 'سکوت', M_START.."سکوت")
	return text
end
--######################################################################--
function rank_reply(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if data.sender_user_id then
		if not tonumber(data.sender_user_id) then return false end
		if cmd == "setrank" then
			redis:set(RedisIndex.."laghab:"..data.sender_user_id,arg.rank)
			tdbot.sendMention(arg.chat_id,data.sender_user_id, data.id,M_START.."مقام کاربر [ "..data.sender_user_id.." ] تنظیم شد به : ( "..arg.rank.." )"..EndPm,15,string.len(data.sender_user_id))
		end
		if cmd == "delrank" then
			redis:del(RedisIndex.."laghab:"..data.sender_user_id)
			tdbot.sendMention(arg.chat_id,data.sender_user_id, data.id,M_START.."مقام کاربر [ "..data.sender_user_id.." ] حذف شد"..EndPm,15,string.len(data.sender_user_id))
		end
	end
end
--######################################################################--
function rank_username(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if not data.id then return end
	if data.id then
		if cmd == "setrank" then
			redis:set(RedisIndex.."laghab:"..data.id,arg.rank)
			tdbot.sendMention(arg.chat_id,data.id, data.id,M_START.."مقام کاربر [ "..data.id.." ] تنظیم شد به : ( "..arg.rank.." )"..EndPm,15,string.len(data.id))
		end
		if cmd == "delrank" then
			redis:del(RedisIndex.."laghab:"..data.id)
			tdbot.sendMention(arg.chat_id,data.id, data.id,M_START.."مقام کاربر [ "..data.id.." ] حذف شد"..EndPm,15,string.len(data.id))
		end
	end
end
--######################################################################--
function rank_id(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	cmd = arg.cmd
	if not tonumber(arg.user_id) then return false end
	if data.id then
		if data.first_name then
			if cmd == "setrank" then
				redis:set(RedisIndex.."laghab:"..data.id,arg.rank)
				tdbot.sendMention(arg.chat_id,data.id, data.id,M_START.."مقام کاربر [ "..data.id.." ] تنظیم شد به : ( "..arg.rank.." )"..EndPm,15,string.len(data.id))
			end
			if cmd == "delrank" then
				redis:del(RedisIndex.."laghab:"..data.id)
				tdbot.sendMention(arg.chat_id,data.id, data.id,M_START.."مقام کاربر [ "..data.id.." ] حذف شد"..EndPm,15,string.len(data.id))
			end
		end
	end
end
--######################################################################--
function info_by_reply(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if tonumber(data.sender_user_id) then
		function info_cb(arg, data)
			if data.username then
				username = "@"..check_markdown(data.username)
			else
				username = ""
			end
			if data.first_name then
				firstname = check_markdown(data.first_name)
			else
				firstname = ""
			end
			if data.last_name then
				lastname = check_markdown(data.last_name)
			else
				lastname = ""
			end
			local hash = 'rank:'..arg.chat_id..':variables'
			local text = ""..M_START.."*نام :* `"..firstname.."`\n"..M_START.."*فامیلی :* `"..lastname.."`\n"..M_START.."*نام کاربری :* "..username.."\n"..M_START.."*آیدی :* `"..data.id.."`\n"
			if data.id == tonumber(MahDiRoO) then
				text = text..M_START..'*مقام :* `سازنده سورس`\n'
			elseif is_sudo1(data.id) then
				text = text..M_START..'*مقام :* `سودو ربات`\n'
			elseif is_admin1(data.id) then
				text = text..M_START..'*مقام :* `ادمین ربات`\n'
			elseif is_owner1(arg.chat_id, data.id) then
				text = text..M_START..'*مقام :* `سازنده گروه`\n'
			elseif is_mod1(arg.chat_id, data.id) then
				text = text..M_START..'*مقام :* `مدیر گروه`\n'
			else
				text = text..M_START..'*مقام :* `کاربر عادی`\n'
			end
			local user_info = {}
			local uhash = 'user:'..data.id
			local user = redis:hgetall(RedisIndex..uhash)
			local um_hash = 'msgs:'..data.id..':'..arg.chat_id
			local gaps = 'msgs:'..arg.chat_id
			local hashss = 'laghab:'..tostring(data.id)
			laghab = redis:get(RedisIndex..hashss) or 'ثبت نشده'
			user_info_msgs = tonumber(redis:get(RedisIndex..um_hash) or 0)
			gap_info_msgs = tonumber(redis:get(RedisIndex..gaps) or 0)
			Percent_= tonumber(user_info_msgs) / tonumber(gap_info_msgs) * 100
			if Percent_ < 10 then
				Percent = '0'..string.sub(Percent_, 1, 4)
			elseif Percent_ >= 10 then
				Percent = string.sub(Percent_, 1, 5)
			end
			if tonumber(Percent) <= 10 then
				UsStatus = "ضعیف 😴"
			elseif tonumber(Percent) <= 20 then
				UsStatus = "معمولی 😊"
			elseif tonumber(Percent) <= 100 then
				UsStatus = "فعال 😎"
			end
			text = text..M_START..'*پیام های گروه :* `'..gap_info_msgs..'`\n'
			text = text..M_START..'*پیام های کاربر :* `'..user_info_msgs..'`\n'
			text = text..M_START..'*درصد پیام کاربر :* `('..Percent..'%)`\n'
			text = text..M_START..'*وضعیت کاربر :* `'..UsStatus..'`\n'
			text = text..M_START..'*لقب کاربر :* `'..laghab..'`'
			tdbot.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
		end
		assert (tdbot_function ({
		_ = "getUser",
		user_id = data.sender_user_id
		}, info_cb, {chat_id=data.chat_id,user_id=data.sender_user_id,msgid=data.id}))
	else
	end
end
--######################################################################--
function info_by_username(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if tonumber(data.id) then
		function info_cb(arg, data)
			if not data.id then return end
			if data.username then
				username = "@"..check_markdown(data.username)
			else
				username = ""
			end
			if data.first_name then
				firstname = check_markdown(data.first_name)
			else
				firstname = ""
			end
			if data.last_name then
				lastname = check_markdown(data.last_name)
			else
				lastname = ""
			end
			local hash = 'rank:'..arg.chat_id..':variables'
			local text = ""..M_START.."*نام :* `"..firstname.."`\n"..M_START.."*فامیلی :* `"..lastname.."`\n"..M_START.."*نام کاربری :* "..username.."\n"..M_START.."*آیدی :* `"..data.id.."`\n"
			if data.id == tonumber(MahDiRoO) then
				text = text..M_START..'*مقام :* `سازنده سورس`\n'
			elseif is_sudo1(data.id) then
				text = text..M_START..'*مقام :* `سودو ربات`\n'
			elseif is_admin1(data.id) then
				text = text..M_START..'*مقام :* `ادمین ربات`\n'
			elseif is_owner1(arg.chat_id, data.id) then
				text = text..M_START..'*مقام :* `سازنده گروه`\n'
			elseif is_mod1(arg.chat_id, data.id) then
				text = text..M_START..'*مقام :* `مدیر گروه`\n'
			else
				text = text..M_START..'*مقام :* `کاربر عادی`\n'
			end
			local user_info = {}
			local uhash = 'user:'..data.id
			local user = redis:hgetall(RedisIndex..uhash)
			local um_hash = 'msgs:'..data.id..':'..arg.chat_id
			local gaps = 'msgs:'..arg.chat_id
			local hashss = 'laghab:'..tostring(data.id)
			laghab = redis:get(RedisIndex..hashss) or 'ثبت نشده'
			user_info_msgs = tonumber(redis:get(RedisIndex..um_hash) or 0)
			gap_info_msgs = tonumber(redis:get(RedisIndex..gaps) or 0)
			Percent_= tonumber(user_info_msgs) / tonumber(gap_info_msgs) * 100
			if Percent_ < 10 then
				Percent = '0'..string.sub(Percent_, 1, 4)
			elseif Percent_ >= 10 then
				Percent = string.sub(Percent_, 1, 5)
			end
			if tonumber(Percent) <= 10 then
				UsStatus = "ضعیف 😴"
			elseif tonumber(Percent) <= 20 then
				UsStatus = "معمولی 😊"
			elseif tonumber(Percent) <= 100 then
				UsStatus = "فعال 😎"
			end
			text = text..M_START..'*پیام های گروه :* `'..gap_info_msgs..'`\n'
			text = text..M_START..'*پیام های کاربر :* `'..user_info_msgs..'`\n'
			text = text..M_START..'*درصد پیام کاربر :* `('..Percent..'%)`\n'
			text = text..M_START..'*وضعیت کاربر :* `'..UsStatus..'`\n'
			text = text..M_START..'*لقب کاربر :* `'..laghab..'`'
			tdbot.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
		end
		assert (tdbot_function ({
		_ = "getUser",
		user_id = data.id
		}, info_cb, {chat_id=arg.chat_id,user_id=data.id,msgid=msgid}))
	end
end
--######################################################################--
function info_by_id(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if tonumber(data.id) then
		if data.username then
			username = "@"..check_markdown(data.username)
		else
			username = ""
		end
		if data.first_name then
			firstname = check_markdown(data.first_name)
		else
			firstname = ""
		end
		if data.last_name then
			lastname = check_markdown(data.last_name)
		else
			lastname = ""
		end
		local hash = 'rank:'..arg.chat_id..':variables'
		local text = ""..M_START.."*نام :* `"..firstname.."`\n"..M_START.."*فامیلی :* `"..lastname.."`\n"..M_START.."*نام کاربری :* "..username.."\n"..M_START.."*آیدی :* `"..data.id.."`\n"
		if data.id == tonumber(MahDiRoO) then
			text = text..M_START..'*مقام :* `سازنده سورس`\n'
		elseif is_sudo1(data.id) then
			text = text..M_START..'*مقام :* `سودو ربات`\n'
		elseif is_admin1(data.id) then
			text = text..M_START..'*مقام :* `ادمین ربات`\n'
		elseif is_owner1(arg.chat_id, data.id) then
			text = text..M_START..'*مقام :* `سازنده گروه`\n'
		elseif is_mod1(arg.chat_id, data.id) then
			text = text..M_START..'*مقام :* `مدیر گروه`\n'
		else
			text = text..M_START..'*مقام :* `کاربر عادی`\n'
		end
		local user_info = {}
		local uhash = 'user:'..data.id
		local user = redis:hgetall(RedisIndex..uhash)
		local um_hash = 'msgs:'..data.id..':'..arg.chat_id
		local gaps = 'msgs:'..arg.chat_id
		local hashss = 'laghab:'..tostring(data.id)
		laghab = redis:get(RedisIndex..hashss) or 'ثبت نشده'
		user_info_msgs = tonumber(redis:get(RedisIndex..um_hash) or 0)
		gap_info_msgs = tonumber(redis:get(RedisIndex..gaps) or 0)
		Percent_= tonumber(user_info_msgs) / tonumber(gap_info_msgs) * 100
		if Percent_ < 10 then
			Percent = '0'..string.sub(Percent_, 1, 4)
		elseif Percent_ >= 10 then
			Percent = string.sub(Percent_, 1, 5)
		end
		if tonumber(Percent) <= 10 then
			UsStatus = "ضعیف 😴"
		elseif tonumber(Percent) <= 20 then
			UsStatus = "معمولی 😊"
		elseif tonumber(Percent) <= 100 then
			UsStatus = "فعال 😎"
		end
		text = text..M_START..'*پیام های گروه :* `'..gap_info_msgs..'`\n'
		text = text..M_START..'*پیام های کاربر :* `'..user_info_msgs..'`\n'
		text = text..M_START..'*درصد پیام کاربر :* `('..Percent..'%)`\n'
		text = text..M_START..'*وضعیت کاربر :* `'..UsStatus..'`\n'
		text = text..M_START..'*لقب کاربر :* `'..laghab..'`'
		tdbot.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
	end
end
--######################################################################--
function pre_processLim(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if not is_mod(msg) then
	local add_lock = redis:hget(RedisIndex..'addmeminv', msg.to.id)
	if add_lock == 'on' then
		local chsh = 'addpm'..msg.to.id
		local hsh = redis:get(RedisIndex..chsh)
		local chkpm = redis:get(RedisIndex..msg.from.id..'chkuserpm'..msg.to.id)
		if msg.from.username ~= '' then
			username = '@'..check_markdown(msg.from.username)
		else
			username = check_markdown(msg.from.print_name)
		end
		local setadd = redis:hget(RedisIndex..'addmemset', msg.to.id) or 10
		if msg.adduser then
			tdbot.getUser(msg.content.member_user_ids[0], function(TM, BD)
				if BD.type._ == 'userTypeBot' then
					if not hsh then
						tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n`شما یک ربات به گروه اضافه کردید`\n`لطفا یک کاربر اضافه کنید.`'..EndPm, 1, 'md')
					end
					return
				end
				if #msg.content.member_user_ids > 0 then
					if not hsh then
						tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n`شما تعداد '..(#msg.content.member_user_ids + 1)..' کاربر را اضافه کردید!`\n`اما فقط یک کاربر برای شما ذخیره شد!`\n`لطفا کاربران رو تک به تک اضافه کنید تا محدودیت برای شما برداشته شود`'..EndPm, 1, 'md')
					end
				end
				local chash = msg.content.member_user_ids[0]..'chkinvusr'..msg.from.id..'chat'..msg.to.id
				local chk = redis:get(RedisIndex..chash)
				if not chk then
					redis:set(RedisIndex..chash, true)
					local achash = 'addusercount'..msg.from.id
					local count = redis:hget(RedisIndex..achash, msg.to.id) or 0
					redis:hset(RedisIndex..achash, msg.to.id, (tonumber(count) + 1))
					local permit = redis:hget(RedisIndex..achash, msg.to.id)
					if tonumber(permit) < tonumber(setadd) then
						local less = tonumber(setadd) - tonumber(permit)
						if not hsh then
							tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n*شما تعداد* `'..permit..'` *کاربر را به این گروه اضافه کردید.*\n*باید* `'..less..'` *کاربر دیگر برای رفع محدودیت چت اضافه کنید.*'..EndPm, 1, 'md')
						end
					elseif tonumber(permit) == tonumber(setadd) then
						if not hsh then
							tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n*شما اکنون میتوانید پیام ارسال کنید.*'..EndPm, 1, 'md')
						end
					end
				else
					if not hsh then
						tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n*شما قبلا این کاربر را به گروه اضافه کرده اید!*'..EndPm, 1, 'md')
					end
				end
				end, nil)
			end
			local permit = redis:hget(RedisIndex..'addusercount'..msg.from.id, msg.to.id) or 0
			if tonumber(permit) < tonumber(setadd) then
				tdbot.deleteMessages(msg.to.id, {[0] = msg.id}, true, dl_cb, nil)
				if not chkpm then
					redis:set(RedisIndex..msg.from.id..'chkuserpm'..msg.to.id, true)
					tdbot.sendMessage(msg.to.id, 0, 1, M_START..''..username..'\n`شما باید` '..setadd..' `کاربر دیگر رابه به گروه دعوت کنید تا بتوانید پیام ارسال کنید`'..EndPm, 1, 'md')
				end
				return
			end
		end
	end
end
--######################################################################--
function Lock_Delmsg(msg, stats, fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex..''..stats..':'..msg.chat_id) == 'Enable' then
		local rfa = M_START.."*قفل* `"..fa.."` *از قبل فعال بود.*"..EndPm.."\n*حالت قفل :* `حذف پیام`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
	else
		local rfa = M_START.."*قفل* `"..fa.."` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *فعال شد.*"..EndPm.."\n*حالت قفل :* `حذف پیام`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
		redis:set(RedisIndex..''..stats..':'..msg.chat_id, 'Enable')
	end
end
--######################################################################--
function Lock_Delmsg_warn(msg, stats, fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex..''..stats..':'..msg.chat_id) == 'Warn' then
		local rfa = M_START.."*قفل* `"..fa.."` *از قبل فعال بود.*"..EndPm.."\n*حالت قفل :* `اخطار`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
	else
		local rfa = M_START.."*قفل* `"..fa.."` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *فعال شد.*"..EndPm.."\n*حالت قفل :* `اخطار`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
		redis:set(RedisIndex..''..stats..':'..msg.chat_id, 'Warn')
	end
end
--######################################################################--
function Lock_Delmsg_kick(msg, stats, fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex..''..stats..':'..msg.chat_id) == 'Kick' then
		local rfa = M_START.."*قفل* `"..fa.."` *از قبل فعال بود.*"..EndPm.."\n*حالت قفل :* `اخراج`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
	else
		local rfa = M_START.."*قفل* `"..fa.."` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *فعال شد.*"..EndPm.."\n*حالت قفل :* `اخراج`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
		redis:set(RedisIndex..''..stats..':'..msg.chat_id, 'Kick')
	end
end
--######################################################################--
function Lock_Delmsg_mute(msg, stats, fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex..''..stats..':'..msg.chat_id) == 'Mute' then
		local rfa = M_START.."*قفل* `"..fa.."` *از قبل فعال بود.*"..EndPm.."\n*حالت قفل :* `سکوت`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
	else
		local rfa = M_START.."*قفل* `"..fa.."` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *فعال شد.*"..EndPm.."\n*حالت قفل :* `سکوت`"
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
		redis:set(RedisIndex..''..stats..':'..msg.chat_id, 'Mute')
	end
end
--######################################################################--
function Unlock_Delmsg(msg, stats, fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if redis:get(RedisIndex..''..stats..':'..msg.chat_id) then
		local rfa = M_START.."*قفل* `"..fa.."` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *غیرفعال شد.*"..EndPm..""
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
		redis:del(RedisIndex..''..stats..':'..msg.chat_id)
	else
		local rfa = M_START.."*قفل* `"..fa.."` *از قبل فعال نبود.*"..EndPm..""
		tdbot.sendMessage(msg.chat_id , msg.id, 1, rfa, 0, 'md')
	end
end
--######################################################################--
function modlist(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local data = load_data(_config.moderation.data)
	local i = 1
	if not data[tostring(msg.chat_id)] then
		return M_START.."`گروه در` #لیست `گروه ربات  نیست`"..EndPm
	end
	if next(data[tostring(msg.to.id)]['mods']) == nil then
		return M_START.."`در حال حاضر هیچ مدیری برای گروه انتخاب نشده است`"..EndPm
	end
	message = M_START..'*لیست مدیران گروه :*\n'
	for k,v in pairs(data[tostring(msg.to.id)]['mods'])
		do
		message = message ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	return message
end
--######################################################################--
function ownerlist(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local data = load_data(_config.moderation.data)
	local i = 1
	if not data[tostring(msg.to.id)] then
		return M_START.."`گروه در` #لیست `گروه ربات  نیست`"..EndPm
	end
	if next(data[tostring(msg.to.id)]['owners']) == nil then
		return M_START.."`در حال حاضر هیچ مالکی برای گروه انتخاب نشده است`"..EndPm
	end
	message = M_START..'*لیست مالکین گروه :*\n'
	for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
		message = message ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	return message
end
--######################################################################--
function pre_processMon(msg)
	if gp_type(msg.chat_id) == "pv" and   msg.content.text and not is_admin(msg) then
		local chkmonshi = redis:get(RedisIndex..msg.from.id..'chkusermonshi')
		local hash = ('bot:pm')
		local pm = redis:get(RedisIndex..hash)
		local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
		local M_START = StartPm[math.random(#StartPm)]
		if not chkmonshi then
			redis:set(RedisIndex..msg.from.id..'chkusermonshi', true)
			redis:setex(RedisIndex..msg.from.id..'chkusermonshi', 86400, true)
			tdbot.sendMessage(msg.chat_id , msg.id, 1, check_markdown(pm), 0, 'md')
			tdbot.sendMessage(gp_sudo , 0, 1,M_START.."`شخصی وارد پیوی ربات شد :`\n*پیام :*\n"..check_markdown(msg.content.text).."\n*آیدی فرستنده :*\n`"..msg.sender_user_id.."`"..EndPm, 0, 'md')
		else
			tdbot.sendMessage(gp_sudo , 0, 1,M_START.."`شخصی وارد پیوی ربات شد :`\n*پیام :*\n"..check_markdown(msg.content.text).."\n*آیدی فرستنده :*\n`"..msg.sender_user_id.."`"..EndPm, 0, 'md')
		end
	end
end
--######################################################################--
function pre_processGroup(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local chat = msg.to.id
	local user = msg.from.id
	local data = load_data(_config.moderation.data)
	local checkmod = true
	if checkmod and msg.text and msg.to.type == 'channel' then
		checkmod = false
		tdbot.getChannelMembers(msg.to.id, 0, 200, 'Administrators', nil, function(a, b)
			local secchk = true
			for k,v in pairs(b.members) do
				if v.user_id == tonumber(our_id) then
					secchk = false
				end
			end
			if secchk then
				checkmod = false
				return tdbot.sendMessage(msg.to.id, 0, 1, M_START..'`لطفا برای کارکرد کامل دستورات، ربات را به مدیر گروه ارتقا دهید.`'..EndPm, 1, "md")
			end
			end, nil)
		end
	local function welcome_cb(arg, data)
		local url , res = http.request('http://api.beyond-dev.ir/time/')
		if res ~= 200 then return "No connection" end
		local jdat = json:decode(url)
		administration = load_data(_config.moderation.data)
		if redis:get(RedisIndex..'setwelcome:'..msg.chat_id) then
			welcome = redis:get(RedisIndex..'setwelcome:'..msg.chat_id)
		else
			welcome = M_START.."`به گروه خوشآمدید`"..EndPm
		end
		if administration[tostring(arg.chat_id)]['rules'] then
			rules = administration[arg.chat_id]['rules']
		else
			rules = M_START.."`قوانین برای گروه ثبت نشده است`"..EndPm
		end
		if data.username then
			user_name = "@"..check_markdown(data.username)
		else
			user_name = ""
		end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name..' '..(data.last_name or '')))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{time}", jdat.ENtime)
		local welcome = welcome:gsub("{date}", jdat.ENdate)
		local welcome = welcome:gsub("{timefa}", jdat.FAtime)
		local welcome = welcome:gsub("{datefa}", jdat.FAdate)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
		if msg.adduser then
			welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
			if welcome == 'Enable' then
				tdbot.getUser(msg.adduser, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
			else
				return false
			end
		end
		if msg.joinuser then
			welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
			if welcome == 'Enable' then
				tdbot.getUser(msg.sender_user_id, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
			else
				return false
			end
		end
	end		
end