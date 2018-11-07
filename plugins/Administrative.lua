local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
local data = load_data(_config.moderation.data)
if tonumber(msg.from.id) == MahDiRoO then
if ((mr_roo[1]:lower() == 'save') or (mr_roo[1] == "ذخیره پلاگین")) and mr_roo[2] then
	if not redis:get(RedisIndex..'AutoDownload:'..msg.to.id) then
		return M_START..'*دانلود خودکار در گروه شما فعال نمیباشد*'..EndPm..'\n*برای فعال سازی از دستور زیر استفاده کنید :*\n `"Setdow"` *&&* `"تنظیم دانلود"`'
	end
	if tonumber(msg.reply_to_message_id) ~= 0  then
		function get_filemsg(arg, data)
			function get_fileinfo(arg,data)
				if data.content._ == 'messageDocument' then
					fileid = data.content.document.document.id
					filename = data.content.document.file_name
					file_dl(document_id)
					sleep(1)
					if (filename:lower():match('.lua$')) then
						local pathf = tcpath..'/files/documents/'..filename
						if pl_exi(filename) then
							local pfile = 'plugins/'..mr_roo[2]..'.lua'
							os.rename(pathf, pfile)
							tdbot.sendMessage(msg.to.id, msg.id,1, M_START..'*پلاگین*\n`'..mr_roo[2]..'`\n*در ربات ذخیره شد.*'..EndPm, 1, 'md')
						else
							tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*فایل مورد نظر را دوباره ارسال کنید*'..EndPm, 1, 'md')
						end
					else
						tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*فایل پلاگین نمیباشد*'..EndPm, 1, 'md')
					end
				else
					return
				end
			end
			tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, get_fileinfo, nil)
		end
		tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_to_message_id }, get_filemsg, nil)
	end
end
if ((mr_roo[1]:lower() == "sendfile") or (mr_roo[1] == "ارسال فایل")) and mr_roo[2] and mr_roo[3] then
	local send_file = "./"..mr_roo[2].."/"..mr_roo[3]
	tdbot.sendDocument(msg.to.id, send_file, M_START..""..channel_username..""..EndPm, nil, msg.id, 0, 1, nil, dl_cb, nil)
end
if ((mr_roo[1]:lower() == "sendplug") or (mr_roo[1] == "ارسال پلاگین")) and mr_roo[2] then
	local plug = "./plugins/"..mr_roo[2]..".lua"
	tdbot.sendDocument(msg.to.id, plug, M_START..""..channel_username..""..EndPm, nil, msg.id, 0, 1, nil, dl_cb, nil)
end
end
--######################################################################--
if tonumber(msg.from.id) == SUDO then
if ((mr_roo[1]:lower() == "setsudo") or (mr_roo[1] == "تنظیم سودو")) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="visudo"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="visudo"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "remsudo") or (mr_roo[1] == "حذف سودو")) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="desudo"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="desudo"})
	end
end
--######################################################################--
end
if ((mr_roo[1]:lower() == "config") or (mr_roo[1] == "پیکربندی")) and is_admin(msg) and is_JoinChannel(msg) then
	return set_config(msg)
end
--######################################################################--
if (matches[1]:lower() == "testspeed" or matches[1] == "سرعت سرور") and is_admin(msg) and is_JoinChannel(msg) then
	local io = io.popen("speedtest --share"):read("*all")
	link = io:match("http://www.speedtest.net/result/%d+.png")
	local file = download_to_file(link,'speed.png')
	tdbot.sendPhoto(msg.to.id, msg.id, file, 0, {}, 0, 0, M_START..""..channel_username..""..EndPm, 0, 0, 1, nil, dl_cb, nil)
end
--######################################################################--
if is_sudo(msg) then
if ((mr_roo[1]:lower() == 'add') or (mr_roo[1] == "نصب گروه")) and not redis:get(RedisIndex..'ExpireDate:'..msg.to.id) and is_JoinChannel(msg) then
	redis:set(RedisIndex..'ExpireDate:'..msg.to.id,true)
	redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, 180, true)
	if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
		redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'rem') or (mr_roo[1] == "حذف گروه")) and is_JoinChannel(msg) then
	if redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
		redis:del(RedisIndex..'CheckExpire::'..msg.to.id)
	end
	redis:del(RedisIndex..'ExpireDate:'..msg.to.id)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'gid') or (mr_roo[1] == "آیدی گروه")) and is_JoinChannel(msg) then
	tdbot.sendMessage(msg.to.id, msg.id, 1, '`'..msg.to.id..'`', 1,'md')
end
--######################################################################--
if (mr_roo[1]:lower() == "panelsudo" or mr_roo[1] == "پنل سودو") and is_admin(msg) and is_JoinChannel(msg) then
	local function inline_query_cb(arg, data)
		if data.results and data.results[0] then
			redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.to.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
		else
			text = M_START.."مشکل فنی در ربات هلپر"..EndPm
			return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
		end
	end
	tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.to.id, 0, 0, "Sudo:"..msg.to.id, 0, inline_query_cb, nil)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'leave') or (mr_roo[1] == "خروج")) and mr_roo[2] and is_JoinChannel(msg) then
	tdbot.sendMessage(mr_roo[2], 0, 1, M_START..'ربات با دستور سودو از گروه خارج شد.\nبرای اطلاعات بیشتر با سودو تماس بگیرید.'..EndPm..'\n`سودو ربات :` '..check_markdown(sudo_username), 1, 'md')
	tdbot.changeChatMemberStatus(mr_roo[2], our_id, 'Left', dl_cb, nil)
	tdbot.sendMessage(gp_sudo, msg.id, 1, M_START..'ربات با موفقیت از گروه '..mr_roo[2]..' خارج شد.'..EndPm..'\nتوسط : @'..check_markdown(msg.from.username or '')..' | `'..msg.from.id..'`', 1,'md')
end
--######################################################################--
if ((mr_roo[1]:lower() == 'charge') or (mr_roo[1] == "شارژ")) and mr_roo[2] and mr_roo[3] and is_JoinChannel(msg) then
	if string.match(mr_roo[2], '^-%d+$') then
		if tonumber(mr_roo[3]) > 0 and tonumber(mr_roo[3]) < 1001 then
			local extime = (tonumber(mr_roo[3]) * 86400)
			redis:setex(RedisIndex..'ExpireDate:'..mr_roo[2], extime, true)
			if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
				redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
			end
			tdbot.sendMessage(gp_sudo, 0, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..mr_roo[2].."`\n>_مقدار شارژ انجام داده ؛_ `"..mr_roo[3].."`\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..mr_roo[2].."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..mr_roo[2].."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..mr_roo[2].."`", 1, 'md')
			tdbot.sendMessage(mr_roo[2], 0, 1, M_START..'ربات توسط ادمین به مدت `'..mr_roo[3]..'` روز شارژ شد\nبرای مشاهده زمان شارژ گروه دستور /expire استفاده کنید...'..EndPm,1 , 'md')
		else
			tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*تعداد روزها باید عددی از 1 تا 1000 باشد.*'..EndPm, 1, 'md')
		end
	end
end
--######################################################################--
if (mr_roo[1]:lower() == 'full' or mr_roo[1] == 'نامحدود') and is_JoinChannel(msg) then
	local linkgp = data[tostring(chat)]['settings']['linkgp']
	if not linkgp then
		return M_START..'`لطفا قبل از شارژ گروه لینک گروه را تنظیم کنید`'..EndPm..'\n*"تنظیم لینک"\n"setlink"*'
	end
	local data = load_data(_config.moderation.data)
	local i = 1
	if next(data[tostring(msg.to.id)]['owners']) == nil then
		return M_START..'`لطفا قبل از شارژ گروه مالک گروه را تنظیم کنید`\n_یا میتوانید از دستور زیر استفاده کنید_'..EndPm..'\n*"Config"*\n*"پیکربندی"*'
	end
	message = '\n'
	for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
		message = message ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	if next(data[tostring(msg.to.id)]['mods']) == nil then
		return M_START..'`لطفا قبل از شارژ گروه مدیر گروه را تنظیم کنید`\n_یا میتوانید از دستور زیر استفاده کنید_'..EndPm..'\n*"Config"*\n*"پیکربندی"*'
	end
	message2 = '\n'
	for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
		message2 = message2 ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	redis:set(RedisIndex..'ExpireDate:'..msg.to.id,true)
	if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
		redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
	end
	tdbot.sendMessage(gp_sudo, msg.id, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..msg.to.id.."`\n>_مقدار شارژ انجام داده ؛_ `نامحدود !`\n_>لینک گروه ؛_\n"..check_markdown(linkgp).."\n_>لیست مالک گروه ؛_ "..message.."\n_>لیست مدیران گروه؛_ "..message2.."\n\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..msg.to.id.."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..msg.to.id.."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..msg.to.id.."`", 1, 'md')
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`ربات بدون محدودیت فعال شد !` *( نامحدود )*'..EndPm, 1, 'md')
end
--######################################################################--
if ((mr_roo[1]:lower() == 'jointo') or (mr_roo[1] == "ورود به")) and mr_roo[2] and is_JoinChannel(msg) then
	if string.match(mr_roo[2], '^-%d+$') then
		tdbot.sendMessage(SUDO, msg.id, 1, M_START..'با موفقیت تورو به گروه '..mr_roo[2]..' اضافه کردم.'..EndPm, 1, 'md')
		tdbot.addChatMember(mr_roo[2], SUDO, 0, dl_cb, nil)
		tdbot.sendMessage(mr_roo[2], 0, 1, M_START..'*سودو به گروه اضافه شد.*'..EndPm..'\n`سودو ربات :` '..check_markdown(sudo_username), 1, 'md')
	end
end
--######################################################################--
end
if msg.to.type == 'channel' or msg.to.type == 'chat' then
if ((mr_roo[1]:lower() == 'charge') or (mr_roo[1] == "شارژ")) and mr_roo[2] and not mr_roo[3] and is_sudo(msg) and is_JoinChannel(msg) then
	local linkgp = data[tostring(chat)]['settings']['linkgp']
	if not linkgp then
		return M_START..'`لطفا قبل از شارژ گروه لینک گروه را تنظیم کنید`'..EndPm..'\n*"تنظیم لینک"\n"setlink"*'
	end
	local data = load_data(_config.moderation.data)
	local i = 1
	if next(data[tostring(msg.to.id)]['owners']) == nil then
		return M_START..'`لطفا قبل از شارژ گروه مالک گروه را تنظیم کنید`\n_یا میتوانید از دستور زیر استفاده کنید_'..EndPm..'\n*"Config"*\n*"پیکربندی"*'
	end
	message = '\n'
	for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
		message = message ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	if next(data[tostring(msg.to.id)]['mods']) == nil then
		return M_START..'`لطفا قبل از شارژ گروه مدیر گروه را تنظیم کنید`\n_یا میتوانید از دستور زیر استفاده کنید_'..EndPm..'\n*"Config"*\n*"پیکربندی"*'
	end
	message2 = '\n'
	for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
		message2 = message2 ..i.. '- '..v..' [' ..k.. '] \n'
		i = i + 1
	end
	if tonumber(mr_roo[2]) > 0 and tonumber(mr_roo[2]) < 1001 then
		local extime = (tonumber(mr_roo[2]) * 86400)
		redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, extime, true)
		print(''..extime..'')
		if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
			redis:set(RedisIndex..'CheckExpire::'..msg.to.id)
		end
		tdbot.sendMessage(gp_sudo, msg.id, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..msg.to.id.."`\n>_مقدار شارژ انجام داده ؛_ `"..mr_roo[2].."`\n_>لینک گروه ؛_\n"..check_markdown(linkgp).."\n_>لیست مالک گروه ؛_ "..message.."\n_>لیست مدیران گروه؛_ "..message2.."\n\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..msg.to.id.."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..msg.to.id.."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..msg.to.id.."`", 1, 'md')
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`گروه به مدت` *'..mr_roo[2]..'* `روز شارژ شد.`'..EndPm, 1, 'md')
	else
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*تعداد روزها باید عددی از 1 تا 1000 باشد.*'..EndPm, 1, 'md')
	end
end
--######################################################################--	
if ((mr_roo[1]:lower() == 'expire') or (mr_roo[1] == "اعتبار")) and is_mod(msg) and not mr_roo[2] and is_JoinChannel(msg) then
	local check_time = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
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
		remained_expire = M_START..'`گروه به صورت نامحدود شارژ میباشد!`'..EndPm
	elseif tonumber(check_time) > 1 and check_time < 60 then
		remained_expire = M_START..'`گروه به مدت` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
	elseif tonumber(check_time) > 60 and check_time < 3600 then
		remained_expire = M_START..'`گروه به مدت` *'..min..'* `دقیقه و` *'..sec..'* _ثانیه شارژ میباشد`'..EndPm
	elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
		remained_expire = M_START..'`گروه به مدت` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
	elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
		remained_expire = M_START..'`گروه به مدت` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
	elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
		remained_expire = M_START..'`گروه به مدت` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
	elseif tonumber(check_time) > 31536000 then
		remained_expire = M_START..'`گروه به مدت` *'..year..'* `سال` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
	end
	tdbot.sendMessage(msg.to.id, msg.id, 1, remained_expire, 1, 'md')
end
--######################################################################--
end
if ((mr_roo[1]:lower() == 'expire') or (mr_roo[1] == "اعتبار")) and is_mod(msg) and mr_roo[2] and is_JoinChannel(msg) then
	if string.match(mr_roo[2], '^-%d+$') then
		local check_time = redis:ttl(RedisIndex..'ExpireDate:'..mr_roo[2])
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
			remained_expire = M_START..'`گروه به صورت نامحدود شارژ میباشد!`'..EndPm
		elseif tonumber(check_time) > 1 and check_time < 60 then
			remained_expire = M_START..'`گروه به مدت` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
		elseif tonumber(check_time) > 60 and check_time < 3600 then
			remained_expire = M_START..'`گروه به مدت` *'..min..'* `دقیقه و` *'..sec..'* _ثانیه شارژ میباشد`'..EndPm
		elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
			remained_expire = M_START..'`گروه به مدت` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
		elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
			remained_expire = M_START..'`گروه به مدت` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
		elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
			remained_expire = M_START..'`گروه به مدت` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
		elseif tonumber(check_time) > 31536000 then
			remained_expire = M_START..'`گروه به مدت` *'..year..'* `سال` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndPm
		end
		tdbot.sendMessage(msg.to.id, msg.id, 1, remained_expire, 1, 'md')
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "setadmin") or (mr_roo[1] == "تنظیم ادمین")) and is_sudo(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="adminprom"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="adminprom"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="adminprom"})
	end
end
--######################################################################--
if ((mr_roo[1] == "remadmin") or (mr_roo[1] == "حذف ادمین")) and is_sudo(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_to_message_id_
		}, action_by_reply, {chat_id=msg.to.id,cmd="admindem"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="admindem"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="admindem"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'creategroup') or (mr_roo[1] == "ساخت گروه")) and is_admin(msg) and is_JoinChannel(msg) then
	local text = mr_roo[2]
	tdbot.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
	return M_START..'`گروه ساخته شد`'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'createsuper') or (mr_roo[1] == "ساخت سوپرگروه")) and is_admin(msg) and is_JoinChannel(msg) then
local text = mr_roo[2]
tdbot.createNewChannelChat(text, 1, '@MaTaDoRTeaM', (function(b, d) tdbot.addChatMember(d.id, msg.from.id, 0, dl_cb, nil) end), nil)
	return M_START..'*سوپرگروه ساخته شد و* [`'..msg.from.id..'`] *به گروه اضافه شد.*'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'tosuper') or (mr_roo[1] == "تبدیل به سوپرگروه")) and is_admin(msg) and is_JoinChannel(msg) then
	local id = msg.to.id
	tdbot.migrateGroupChatToChannelChat(id, dl_cb, nil)
	return M_START..'`گروه به سوپر گروه تبدیل شد`'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'import') or (mr_roo[1] == "ورود لینک")) and is_admin(msg) and is_JoinChannel(msg) then
	if mr_roo[2]:match("^([https?://w]*.?telegram.me/joinchat/.*)$") or mr_roo[2]:match("^([https?://w]*.?t.me/joinchat/.*)$") then
		local link = mr_roo[2]
		if link:match('t.me') then
			link = string.gsub(link, 't.me', 'telegram.me')
		end
		tdbot.importChatInviteLink(link, dl_cb, nil)
		return M_START..'*انجام شد*'..EndPm
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'setbotname') or (mr_roo[1] == "تغییر نام ربات")) and is_sudo(msg) and is_JoinChannel(msg) then
	tdbot.changeName(mr_roo[2], dl_cb, nil)
	return M_START..'`اسم ربات تغییر کرد به :`\n*'..mr_roo[2]..'*'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'setbotusername') or (mr_roo[1] == "تغییر یوزرنیم ربات")) and is_sudo(msg) and is_JoinChannel(msg) then
	tdbot.changeUsername(mr_roo[2], dl_cb, nil)
	return M_START..'`یوزرنیم ربات تغییر کرد به :` \n@'..check_markdown(mr_roo[2])..''..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'delbotusername') or (mr_roo[1] == "حذف یوزرنیم ربات")) and is_sudo(msg) and is_JoinChannel(msg) then
	tdbot.changeUsername('', dl_cb, nil)
	return M_START..'*انجام شد*'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'markread') or (mr_roo[1] == "تیک دوم")) and is_sudo(msg) and is_JoinChannel(msg) then
if ((mr_roo[2] == 'on') or (mr_roo[2] == "فعال")) then
	redis:set(RedisIndex..'markread','on')
	return M_START..'`تیک دوم` *روشن*'..EndPm
end
if ((mr_roo[2] == 'off') or (mr_roo[2] == "غیرفعال")) then
	redis:del(RedisIndex..'markread')
	return M_START..'`تیک دوم` *خاموش*'..EndPm
end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'bc') or (mr_roo[1] == "ارسال")) and is_admin(msg) and is_JoinChannel(msg) then
	local text = mr_roo[2]
	tdbot.sendMessage(mr_roo[3], "", 0, text, 0,  "html")
end
--######################################################################--
if ((mr_roo[1]:lower() == 'broadcast') or (mr_roo[1] == "ارسال به همه")) and is_sudo(msg) and is_JoinChannel(msg) then
	local data = load_data(_config.moderation.data)
	local bc = mr_roo[2]
	for k,v in pairs(data) do
		tdbot.sendMessage(k, "", 0, bc, 0,  "html")
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'sudolist') or (mr_roo[1] == "لیست سودو")) and is_sudo(msg) and is_JoinChannel(msg) then
	return sudolist(msg)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'chats') or (mr_roo[1] == "لیست گروه ها")) and is_admin(msg) and is_JoinChannel(msg) then
	return chat_list(msg)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'join') or (mr_roo[1] == "ورود")) and is_admin(msg) and mr_roo[2] and is_JoinChannel(msg) then
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'*شما وارد گروه * '..mr_roo[2]..' *شدید*'..EndPm, 1, 'md')
	tdbot.sendMessage(mr_roo[2], 0, 1, M_START.."*سودو ربات وارد گروه شد*"..EndPm, 1, 'md')
	tdbot.addChatMember(mr_roo[2], msg.from.id, 0, dl_cb, nil)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'rem') or (mr_roo[1] == "حذف گروه")) and mr_roo[2] and is_admin(msg) and is_JoinChannel(msg) then
	local data = load_data(_config.moderation.data)
	data[tostring(mr_roo[2])] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(mr_roo[2])] = nil
	save_data(_config.moderation.data, data)
	return M_START..'*گروه* `'..mr_roo[2]..'` *از گروه های مدیریتی ربات حذف شد.*'..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'adminlist') or (mr_roo[1] == "لیست ادمین")) and is_admin(msg) and is_JoinChannel(msg) then
	return adminlist(msg)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'leave') or (mr_roo[1] == "خروج")) and not mr_roo[2] and is_admin(msg) and is_JoinChannel(msg) then
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`ربات با موفقیت از گروه خارج شد.`'..EndPm, 1,'md')
	tdbot.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'autoleave') or (mr_roo[1] == "خروج خودکار")) and is_admin(msg) and is_JoinChannel(msg) then
	local hash = 'auto_leave_bot'
	if ((mr_roo[2] == 'enable') or (mr_roo[2] == "فعال")) then
		redis:del(RedisIndex..hash)
		return M_START..'*خروج خودکار فعال شد*'..EndPm
	elseif ((mr_roo[2] == 'disable') or (mr_roo[2] == "غیرفعال")) then
		redis:set(RedisIndex..hash, true)
		return M_START..'*خروج خودکار غیرفعال شد*'..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == 'panelgp' or mr_roo[1] == 'پنل گروه') and is_admin(msg) and is_JoinChannel(msg) then
	local function inline_query_cb(arg, data)
		if data.results and data.results[0] then
			redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.to.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
		else
			text = M_START.."مشکل فنی در ربات هلپر"..EndPm
			return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
		end
	end
	tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.to.id, 0, 0, "Menu:"..mr_roo[2], 0, inline_query_cb, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == 'codegift' or mr_roo[1] == 'کدهدیه') and is_sudo(msg) and is_JoinChannel(msg) then
	local code = {'1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
	local charge = {2,5,8,10,11,14,16,18,20}
	local a = code[math.random(#code)]
	local b = code[math.random(#code)]
	local c = code[math.random(#code)]
	local d = code[math.random(#code)]
	local e = code[math.random(#code)]
	local f = code[math.random(#code)]
	local chargetext = charge[math.random(#charge)]
	local codetext = "MaTaDoR-"..a..b..c..d..e..f.."-TeaM"
	redis:sadd(RedisIndex.."CodeGift:", codetext)
	redis:hset(RedisIndex.."CodeGiftt:", codetext , chargetext)
	redis:setex(RedisIndex.."CodeGiftCharge:"..codetext,chargetext * 86400,true)
	local text = M_START.."`کد با موفقیت ساخته شد.\nکد :`\n*"..codetext.."*\n`دارای` *"..chargetext.."* `روز شارژ میباشد .`"..EndPm
	local text2 = M_START.."`کدهدیه جدید ساخته شد.`\n`¤ این کدهدیه دارای` *"..chargetext.."* `روز شارژ میباشد !`\n`¤ طرز استفاده :`\n`¤ ابتدا دستور 'gift' راوارد نماید سپس کدهدیه را وارد کنید :`\n*"..codetext.."*\n`رو در گروه خود ارسال کند ,` *"..chargetext.."* `روز شارژ به گروه آن اضافه میشود !`\n`¤¤¤ توجه فقط یک نفر میتواند از این کد استفاده کند !`"..EndPm
	tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
	tdbot.sendMessage(gp_sudo, msg.id, 1, text2, 1, 'md')
end
--######################################################################--
if (mr_roo[1]:lower() == 'giftlist' or mr_roo[1] == 'لیست کدهدیه') and is_sudo(msg) and is_JoinChannel(msg) then
	local list = redis:smembers(RedisIndex.."CodeGift:")
	local text = '*💢 لیست کد هدیه های ساخته شده :*\n'
	for k,v in pairs(list) do
		local expire = redis:ttl(RedisIndex.."CodeGiftCharge:"..v)
		if expire == -1 then
			EXPIRE = "نامحدود"
		else
			local d = math.floor(expire / 86400 ) + 1
			EXPIRE = d..""
		end
		text = text..k.."- `• کدهدیه :`\n[ *"..v.."* ]\n`• شارژ :`\n*"..EXPIRE.."*\n\n❦❧❦❧❦❧❦❧❦❧\n"
	end
	if #list == 0 then
	text = M_START..'`هیچ کد هدیه , ساخته نشده است`'..EndPm
	end
	tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
end
--######################################################################--
if (mr_roo[1]:lower() == 'gift' or mr_roo[1] == 'استفاده هدیه') and is_owner(msg) and is_JoinChannel(msg) then
	redis:setex(RedisIndex.."Codegift:" .. msg.to.id , 260, true)
	tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."`شما دو دقیقه برای استفاده از کدهدیه زمان دارید.`"..EndPm, 1, 'md')
end
--######################################################################--
end

return {
patterns = {"^[!/#](gift)$","^[!/#](giftlist)$","^[!/#](codegift)$","^[!/#](testspeed)$","^[!/#](panelsudo)$","^[!/#](panelgp) (-%d+)$","^[!/#](config)$","^[!/#](setsudo)$", "^[!/#](remsudo)$","^[!/#](sudolist)$","^[!/#](setsudo) (.*)$", "^[!/#](remsudo) (.*)$","^[!/#](setadmin)$", "^[!/#](remadmin)$","^[!/#](adminlist)$","^[!/#](setadmin) (.*)$", "^[!/#](remadmin) (.*)$","^[!/#](leave)$","^[!/#](autoleave) (.*)$", "^[!/#](creategroup) (.*)$","^[!/#](createsuper) (.*)$","^[!/#](tosuper)$","^[!/#](chats)$","^[!/#](join) (-%d+)$","^[!/#](rem) (-%d+)$","^[!/#](import) (.*)$","^[!/#](setbotname) (.*)$","^[!/#](setbotusername) (.*)$","^[!/#](delbotusername) (.*)$","^[!/#](markread) (.*)$","^[!/#](bc) +(.*) (-%d+)$","^[!/#](broadcast) (.*)$","^[!/#](sendfile) (.*) (.*)$","^[!/#](save) (.*)$","^[!/#](sendplug) (.*)$","^[!/#](savefile) (.*)$","^[!/#](add)$","^[!/#](gid)$","^[!/#](expire)$","^[!/#](expire) (-%d+)$","^[!/#](charge) (-%d+) (%d+)$","^[!/#](charge) (%d+)$","^[!/#](jointo) (-%d+)$","^[!/#](leave) (-%d+)$","^[!/#](full)$","^[!/#](rem)$","^([Cc]onfig)$","^([Tt]estspeed)$","^([Gg]iftlist)$","^([Ss]etsudo)$","^([Rr]emsudo)$","^([Ss]udolist)$","^([Pp]anelsudo)$","^([Pp]anelgp) (-%d+)$","^([Ss]etsudo) (.*)$","^([Rr]emsudo) (.*)$","^([Ss]etadmin)$","^([Rr]emadmin)$","^([Aa]dminlist)$","^([Ss]etadmin) (.*)$","^([Rr]emadmin) (.*)$","^([Ll]eave)$","^([Cc]odegift)$","^([Aa]utoleave) (.*)$","^([Cc]reategroup) (.*)$","^([Cc]reatesuper) (.*)$","^([Tt]osuper)$","^([Cc]hats)$","^([Jj]oin) (-%d+)$","^([Rr]em) (-%d+)$","^([Ii]mport) (.*)$","^([Ss]etbotname) (.*)$","^([Ss]etbotusername) (.*)$","^([Dd]elbotusername) (.*)$","^([Mm]arkread) (.*)$","^([Bb]c) +(.*) (-%d+)$","^([Gg]ift)$","^([Bb]roadcast) (.*)$","^([Ss]endfile) (.*) (.*)$","^([Ss]ave) (.*)$","^([Ss]avefile) (.*)$","^([Ss]endplug) (.*)$","^([Aa]dd)$","^([Gg]id)$","^([Ee]xpire)$","^([Ee]xpire) (-%d+)$","^([Cc]harge) (-%d+) (%d+)$","^([Cc]harge) (%d+)$","^([Jj]ointo) (-%d+)$","^([Ll]eave) (-%d+)$","^([Ff]ull)$","^([Rr]em)$","^(پیکربندی)$","^(نصب گروه)$","^(حذف گروه)$","^(حذف گروه) (-%d+)$","^(لیست سودو)$","^(ساخت گروه) (.*)$","^(ورود به) (-%d+)$","^(ساخت گروه) (.*)$","^(ساخت سوپرگروه) (.*)$","^(ذخیره فایل) (.*)$","^(تنظیم سودو)$","^(تنظیم سودو) (.*)$","^(حذف سودو)$","^(حذف سودو) (.*)$","^(تنظیم ادمین)$","^(تنظیم ادمین) (.*)$","^(حذف ادمین)$","^(حذف ادمین) (.*)$","^(ارسال فایل) (.*)$","^(حذف یوزرنیم ربات) (.*)$","^(تغییر یوزرنیم ربات) (.*)$","^(تغییر نام ربات) (.*)$","^(تبدیل به سوپرگروه)$","^(ارسال به همه) (.*)$","^(لیست گروه ها)$","^(خروج)$","^(خروج) (-%d+)$","^(ارسال پلاگین) (.*)$","^(لیست ادمین)$","^(خروج خودکار) (.*)$","^(شارژ) (-%d+) (%d+)$","^(شارژ) (%d+)$","^(نامحدود)$","^(اعتبار)$","^(اعتبار) (-%d+)$","^(ذخیره پلاگین) (.*)$","^(تیک دوم) (.*)$","^(ارسال) +(.*) (-%d+)$","^(ورود) (-%d+)$","^(پنل سودو)$","^(سرعت سرور)$","^(کدهدیه)$","^(لیست کدهدیه/)$","^(استفاده هدیه)$","^(پنل گروه) (-%d+)$"},
run = MaTaDoRTeaM, pre_process = pre_processTools
}
