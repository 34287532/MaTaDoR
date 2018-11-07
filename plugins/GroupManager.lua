local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
local data = load_data(_config.moderation.data)
local chat = msg.chat_id
local user = msg.sender_user_id
if (mr_roo[1]:lower() == "add" or mr_roo[1] == "نصب گروه" ) and is_sudo(msg) and is_JoinChannel(msg) then
	return modadd(msg)
end
--######################################################################--
if (mr_roo[1]:lower() == "rem" or mr_roo[1] == "حذف گروه" ) and is_sudo(msg) and is_JoinChannel(msg) then
	return modrem(msg)
end
--######################################################################--
if not data[tostring(msg.chat_id)] then return end
if (mr_roo[1]:lower() == "pin" or mr_roo[1] == "سنجاق" ) and is_mod(msg) and msg.reply_id and is_JoinChannel(msg) then
	local lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
	if lock_pin == 'Enable' then
		if is_owner(msg) then
			tdbot.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
			return M_START.."`پیام سجاق شد`"..EndPm
		elseif not is_owner(msg) then
			return
		end
	elseif not lock_pin then
		redis:set(RedisIndex..'pin_msg'..msg.chat_id, msg.reply_id)
		tdbot.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
		return M_START.."`پیام سجاق شد`"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == 'unpin' or mr_roo[1] == "حذف سنجاق") and is_mod(msg) and is_JoinChannel(msg) then
	local lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
	if lock_pin == 'Enable' then
		if is_owner(msg) then
			tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
			return M_START.."`پیام سنجاق شده پاک شد`"..EndPm
		elseif not is_owner(msg) then
			return
		end
	elseif not lock_pin then
		tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
		return M_START.."`پیام سنجاق شده پاک شد`"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "gpinfo" or mr_roo[1] == "اطلاعات گروه") and is_mod(msg) and msg.to.type == "channel" and is_JoinChannel(msg) then
	local function group_info(arg, data)
		if data.description and data.description ~= "" then
			des = check_markdown(data.description)
		else
			des = ""
		end
		ginfo = M_START.."*اطلاعات گروه :*\n`تعداد مدیران :` *"..data.administrator_count.."*\n`تعداد اعضا :` *"..data.member_count.."*\n`تعداد اعضای حذف شده :` *"..data.banned_count.."*\n`تعداد اعضای محدود شده :` *"..data.restricted_count.."*\n`شناسه گروه :` *"..msg.to.id.."*\n`توضیحات گروه :` "..des
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
	end
	tdbot.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
end
--######################################################################--
if (mr_roo[1]:lower() == 'newlink' or mr_roo[1] == "لینک جدید") and is_mod(msg) and is_JoinChannel(msg) then
	local function callback_link (arg, data)
		local administration = load_data(_config.moderation.data)
		if not data.invite_link then
			administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(msg.to.id, msg.id, 1, M_START.."`ربات ادمین گروه نیست`\n`با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید"..EndPm, 1, 'md')
		else
			administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link
			save_data(_config.moderation.data, administration)
			return tdbot.sendMessage(msg.to.id, msg.id, 1, M_START.."`لینک جدید ساخته شد`"..EndPm, 1, 'md')
		end
	end
	tdbot.exportChatInviteLink(msg.to.id, callback_link, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == 'setlink' or mr_roo[1] == "تنظیم لینک") and is_owner(msg) and is_JoinChannel(msg) then
	data[tostring(chat)]['settings']['linkgp'] = 'waiting'
	save_data(_config.moderation.data, data)
	return M_START..'`لطفا لینک گروه خود را ارسال کنید`'..EndPm
end
--######################################################################--
if msg.text then
	local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
	if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
		data[tostring(chat)]['settings']['linkgp'] = msg.text
		save_data(_config.moderation.data, data)
		return M_START.."`لینک جدید ذخیره شد`"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == 'link' or mr_roo[1] == "لینک") and is_mod(msg) and is_JoinChannel(msg) then
	local linkgp = data[tostring(chat)]['settings']['linkgp']
	if not linkgp then
		return M_START.."`ابتدا با دستور` *newlink/* `لینک جدیدی برای گروه بسازید`\n`و اگر ربات سازنده گروه نیس با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید`"..EndPm
	end
	text = M_START.."<b>لینک گروه :</b>\n"..linkgp
	return tdbot.sendMessage(chat, msg.id, 1, text, 1, 'html')
end
--######################################################################--
if (mr_roo[1]:lower() == 'linkpv' or mr_roo[1] == "لینک خصوصی") and is_mod(msg) and is_JoinChannel(msg) then
	if redis:get(RedisIndex..msg.from.id..'chkusermonshi') and not is_admin(msg) then
		tdbot.sendMessage(msg.chat_id, msg.id, 1, "`لطفا پیوی ربات پیام ازسال کنید سپس دستور را وارد نماید.`"..EndPm, 1, 'md')
	else
		local linkgp = data[tostring(chat)]['settings']['linkgp']
		if not linkgp then
			return M_START.."`ابتدا با دستور` *newlink/* `لینک جدیدی برای گروه بسازید`\n`و اگر ربات سازنده گروه نیس با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید`"..EndPm
		end
		tdbot.sendMessage(user, "", 1, "<b>لینک گروه </b> : <code>"..msg.to.title.."</code> :\n"..linkgp, 1, 'html')
		return M_START.."`لینک گروه به چت خصوصی شما ارسال شد`"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "setrules" or mr_roo[1] == "تنظیم قوانین") and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	data[tostring(chat)]['rules'] = mr_roo[2]
	save_data(_config.moderation.data, data)
	return M_START.."`قوانین گروه ثبت شد`"..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == "rules" ) or (mr_roo[1] == "قوانین" )) then
	if not data[tostring(chat)]['rules'] then
		rules = M_START.."`قوانین ثبت نشده است`"..EndPm
	else
		rules = M_START.."*قوانین گروه :*\n"..data[tostring(chat)]['rules']
	end
	return rules
end
--######################################################################--
if (mr_roo[1]:lower() == "res" or mr_roo[1] == "کاربری") and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	tdbot_function ({
	_ = "searchPublicChat",
	username = mr_roo[2]
	}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="res"})
end
--######################################################################--
if (mr_roo[1]:lower() == "whois" or mr_roo[1] == "شناسه") and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	tdbot_function ({
	_ = "getUser",
	user_id = mr_roo[2],
	}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="whois"})
end
--######################################################################--
if (mr_roo[1]:lower() == 'setchar' or mr_roo[1] == "حداکثر حروف مجاز" ) and is_JoinChannel(msg) then
	if not is_mod(msg) then
		return
	end
	local chars_max = mr_roo[2]
	data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
	save_data(_config.moderation.data, data)
	return M_START.."`حداکثر حروف مجاز در پیام تنظیم شد به :` *[ "..mr_roo[2].." ]*"..EndPm
end
--######################################################################--
if (mr_roo[1]:lower() == 'setflood' or mr_roo[1] == "تنظیم پیام مکرر" ) and is_mod(msg) and is_JoinChannel(msg) then
	if tonumber(mr_roo[2]) < 1 or tonumber(mr_roo[2]) > 50 then
		return M_START.."`باید بین` *[2-50]* `تنظیم شود`"..EndPm
	end
	local flood_max = mr_roo[2]
	data[tostring(chat)]['settings']['num_msg_max'] = flood_max
	save_data(_config.moderation.data, data)
	return M_START..'`محدودیت پیام مکرر به` *'..tonumber(mr_roo[2])..'* `تنظیم شد.`'..EndPm
end
--######################################################################--
if (mr_roo[1]:lower() == 'setfloodtime'or mr_roo[1] == "تنظیم زمان بررسی") and is_mod(msg) and is_JoinChannel(msg) then
	if tonumber(mr_roo[2]) < 2 or tonumber(mr_roo[2]) > 10 then
		return M_START.."`باید بین` *[2-10]* `تنظیم شود`"..EndPm
	end
	local time_max = mr_roo[2]
	data[tostring(chat)]['settings']['time_check'] = time_max
	save_data(_config.moderation.data, data)
	return M_START.."`حداکثر زمان بررسی پیام های مکرر تنظیم شد به :` *[ "..mr_roo[2].." ]*"..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'clean' ) or (mr_roo[1] == "پاک کردن" )) and is_owner(msg) then
	if (mr_roo[2] == 'mods' or mr_roo[2] == "مدیران") and is_JoinChannel(msg) then
		if next(data[tostring(chat)]['mods']) == nil then
			return M_START.."هیچ مدیری برای گروه انتخاب نشده است"..EndPm
		end
		for k,v in pairs(data[tostring(chat)]['mods']) do
			data[tostring(chat)]['mods'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return M_START.."`تمام مدیران گروه تنزیل مقام شدند`"..EndPm
	end
	if (mr_roo[2] == 'filterlist' or mr_roo[2] == "لیست فیلتر") and is_JoinChannel(msg) then
		if next(data[tostring(chat)]['filterlist']) == nil then
			return M_START.."`لیست کلمات فیلتر شده خالی است`"..EndPm
		end
		for k,v in pairs(data[tostring(chat)]['filterlist']) do
			data[tostring(chat)]['filterlist'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return M_START.."`لیست کلمات فیلتر شده پاک شد`"..EndPm
	end
	if (mr_roo[2] == 'rules' or mr_roo[2] == "قوانین") and is_JoinChannel(msg) then
		if not data[tostring(chat)]['rules'] then
			return M_START.."`قوانین برای گروه ثبت نشده است`"..EndPm
		end
		data[tostring(chat)]['rules'] = nil
		save_data(_config.moderation.data, data)
		return M_START.."`قوانین گروه پاک شد`"
	end
	if (mr_roo[2] == 'welcome' or mr_roo[2] == "خوشامد") and is_JoinChannel(msg) then
		if not data[tostring(chat)]['setwelcome'] then
			return M_START.."`پیام خوشآمد گویی ثبت نشده است`"..EndPm
		end
		data[tostring(chat)]['setwelcome'] = nil
		save_data(_config.moderation.data, data)
		return M_START.."`پیام خوشآمد گویی پاک شد`"
	end
	if (mr_roo[2] == 'about' or mr_roo[2] == "درباره" ) and is_JoinChannel(msg) then
		if msg.to.type == "chat" then
			if not data[tostring(chat)]['about'] then
				return M_START.."`پیامی مبنی بر درباره گروه ثبت نشده است`"..EndPm
			end
			data[tostring(chat)]['about'] = nil
			save_data(_config.moderation.data, data)
		elseif msg.to.type == "channel" then
			tdbot.changeChannelDescription(chat, "", dl_cb, nil)
		end
		return M_START.."`پیام مبنی بر درباره گروه پاک شد`"..EndPm
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == 'clean' ) or (mr_roo[1] == "پاک کردن" )) and is_admin(msg) then
	if (mr_roo[2] == 'owners' or mr_roo[2] == "مالکان" ) and is_JoinChannel(msg) then
		if next(data[tostring(chat)]['owners']) == nil then
			return M_START.."`مالکی برای گروه انتخاب نشده است`"..EndPm
		end
		for k,v in pairs(data[tostring(chat)]['owners']) do
			data[tostring(chat)]['owners'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return M_START.."`تمامی مالکان گروه تنزیل مقام شدند`"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "setname" or mr_roo[1] == "تنظیم نام" ) and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	local gp_name = mr_roo[2]
	tdbot.changeChatTitle(chat, gp_name, dl_cb, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == "setabout" or mr_roo[1] == "تنظیم درباره") and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	if msg.to.type == "channel" then
		tdbot.changeChannelDescription(chat, mr_roo[2], dl_cb, nil)
	elseif msg.to.type == "chat" then
		data[tostring(chat)]['about'] = mr_roo[2]
		save_data(_config.moderation.data, data)
	end
	return M_START.."`پیام مبنی بر درباره گروه ثبت شد`"..EndPm
end
--######################################################################--
if (mr_roo[1]:lower() == "about" or mr_roo[1] == "درباره" ) and msg.to.type == "chat" and is_owner(msg) and is_JoinChannel(msg) then
	if not data[tostring(chat)]['about'] then
		about = M_START.."`پیامی مبنی بر درباره گروه ثبت نشده است`"..EndPm
	else
		about = M_START.."*درباره گروه :*\n"..data[tostring(chat)]['about']
	end
	return about
end
--######################################################################--
if (mr_roo[1]:lower() == 'filter' or mr_roo[1] == "فیلتر" ) and is_mod(msg) and is_JoinChannel(msg) then
	return filter_word(msg, mr_roo[2])
end
--######################################################################--
if (mr_roo[1]:lower() == 'unfilter' or mr_roo[1] == "حذف فیلتر" ) and is_mod(msg) and is_JoinChannel(msg) then
	return unfilter_word(msg, mr_roo[2])
end
--######################################################################--
if (mr_roo[1]:lower() == 'filterlist' or mr_roo[1] == "لیست فیلتر") and is_mod(msg) and is_JoinChannel(msg) then
	return filter_list(msg)
end
--######################################################################--
if (mr_roo[1]:lower() == "settings" or mr_roo[1] == "تنظیمات") and is_mod(msg) and is_JoinChannel(msg) then
	return group_settings(msg, target)
end
--######################################################################--
if (mr_roo[1]:lower() == "panel" or mr_roo[1] == "پنل") and not mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	local function inline_query_cb(arg, data)
		if data.results and data.results[0] then
			redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.to.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
		else
			text = M_START.."مشکل فنی در ربات هلپر"..EndPm
			return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
		end
	end
	tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.to.id, 0, 0, "Menu:"..msg.to.id, 0, inline_query_cb, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == "panelpv" or mr_roo[1] == "پنل خصوصی") and is_mod(msg) and not mr_roo[2] and is_JoinChannel(msg) then
	if not redis:get(RedisIndex..msg.from.id..'chkusermonshi') and not is_sudo(msg) then
		tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."`شما برای اجرای این دستور ابتدا باید خصوصی ربات پیام دهید.`"..EndPm, 1, 'md')
	else
		local function inline_query_cb(arg, data)
			if data.results and data.results[0] then
				redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.from.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
			else
				text = M_START.."مشکل فنی در ربات هلپر"..EndPm
				return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
			end
		end
		tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.from.id, 0, 0, "Menu:"..msg.to.id, 0, inline_query_cb, nil)
		tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`پنل به خصوصی شما ارسال شد.`"..EndPm, 0, "md")
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "helppv" or mr_roo[1] == "راهنما خصوصی") and is_mod(msg) and not mr_roo[2] and is_JoinChannel(msg) then
	if not redis:get(RedisIndex..msg.from.id..'chkusermonshi') and not is_sudo(msg) then
		tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."`شما برای اجرای این دستور ابتدا باید خصوصی ربات پیام دهید.`"..EndPm, 1, 'md')
	else
		local function inline_query_cb(arg, data)
			if data.results and data.results[0] then
				redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.from.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
			else
				text = M_START.."مشکل فنی در ربات هلپر"..EndPm
				return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
			end
		end
		tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.from.id, 0, 0, "Help:"..msg.to.id, 0, inline_query_cb, nil)
		tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`راهنما به خصوصی شما ارسال شد.`"..EndPm, 0, "md")
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "help" or mr_roo[1] == "راهنما") and is_mod(msg) and is_JoinChannel(msg) then
	local function inline_query_cb(arg, data)
		if data.results and data.results[0] then
			redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.to.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
		else
			text = "مشکل فنی در ربات هلپر"..EndPm
			return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
		end
	end
	tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.to.id, 0, 0, "Help:"..msg.to.id, 0, inline_query_cb, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == "welcome" or mr_roo[1] == "خوشامد") and is_mod(msg) then
	if (mr_roo[2] == "enable" or mr_roo[2] == "فعال" ) and is_JoinChannel(msg) then
		welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
		if welcome == 'Enable' then
			return M_START.."`خوشآمد گویی از قبل فعال بود`"..EndPm
		else
			redis:set(RedisIndex..'welcome:'..msg.chat_id, 'Enable')
			return M_START.."`خوشآمد گویی فعال شد`"..EndPm
		end
	end
	if (mr_roo[2] == "disable" or mr_roo[2] == "غیرفعال" ) and is_JoinChannel(msg) then
		welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
		if welcome == 'Enable' then
			redis:del(RedisIndex..'welcome:'..msg.chat_id)
			return M_START.."`خوشآمد گویی غیرفعال شد`"..EndPm
		else
			return M_START.."`خوشآمد گویی از قبل فعال نبود`"..EndPm
		end
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "setwelcome" or mr_roo[1] == "تنظیم خوشامد") and mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	redis:set(RedisIndex..'setwelcome:'..msg.chat_id, mr_roo[2])
	return M_START.."`پیام خوشآمد گویی تنظیم شد به :`\n*"..mr_roo[2].."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{rules} ➣ نمایش قوانین گروه_\n_{time} ➣ ساعت به زبان انگلیسی _\n_{date} ➣ تاریخ به زبان انگلیسی _\n_{timefa} ➣ ساعت به زبان فارسی _\n_{datefa} ➣ تاریخ به زبان فارسی _\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n`استفاده کنید`"..EndPm
end
--######################################################################--
end

return {
patterns ={"^[!/#](pin)$","^[!/#](unpin)$","^[!/#](gpinfo)$","^[!/#](add)$","^[!/#](rem)$","^[!/#](panel)$","^[!/#](helppv)$","^[!/#](panelpv)$","^[!/#](help)$","^[!/#](settings)$","^[!/#](link)$","^[!/#](linkpv)$","^[!/#](setlink)$","^[!/#](newlink)$","^[!/#](rules)$","^[!/#](setrules) (.*)$","^[!/#](about)$","^[!/#](setabout) (.*)$","^[!/#](setname) (.*)$","^[!/#](clean) (.*)$","^[!/#](setflood) (%d+)$","^[!/#](setchar) (%d+)$","^[!/#](setfloodtime) (%d+)$","^[!/#](res) (.*)$","^[!/#](whois) (%d+)$","^[#!/](filter) (.*)$","^[#!/](unfilter) (.*)$","^[#!/](filterlist)$","^[!/#](setwelcome) (.*)","^[!/#](welcome) (.*)$","^([Pp]in)$","^([Hh]elppv)$","^([Uu]npin)$","^([Gg]pinfo)$","^([Aa]dd)$","^([Rr]em)$","^([Pp]anel)$","^([Pp]anelpv)$","^([Hh]elp)$","^([Ss]ettings)$","^([Ll]ink)$","^([Ll]inkpv)$","^([Ss]etlink)$","^([Nn]ewlink)$","^([Rr]ules)$","^([Ss]etrules) (.*)$","^([Aa]bout)$","^([Ss]etabout) (.*)$","^([Ss]etname) (.*)$","^([Cc]lean) (.*)$","^([Ss]etflood) (%d+)$","^([Ss]etchar) (%d+)$","^([Ss]etfloodtime) (%d+)$","^([Rr]es) (.*)$","^([Ww]hois) (%d+)$","^([Ff]ilter) (.*)$","^([Uu]nfilter) (.*)$","^([Ff]ilterlist)$","^([Ss]etwelcome) (.*)","^([Ww]elcome) (.*)$","^([https?://w]*.?t.me/joinchat/%S+)$","^([https?://w]*.?telegram.me/joinchat/%S+)$",'^(تنظیمات)$','^(پنل)$','^(پنل خصوصی)$','^(سنجاق)$','^(حذف سنجاق)$','^(نصب گروه)$','^(حذف گروه)$','^(لینک جدید)$','^(لینک جدید) (خصوصی)$','^(اطلاعات گروه)$','^(دستورات) (.*)$','^(قوانین)$','^(لینک)$','^(راهنما)$','^(تنظیم لینک)$','^(تنظیم قوانین) (.*)$','^(لینک) (خصوصی)$','^(کاربری) (.*)$','^(شناسه) (%d+)$','^(تنظیم پیام مکرر) (%d+)$','^(تنظیم زمان بررسی) (%d+)$','^(حداکثر حروف مجاز) (%d+)$','^(پاک کردن) (.*)$','^(درباره)$','^(تنظیم نام) (.*)$','^(تنظیم درباره) (.*)$','^(لیست فیلتر)$','^(فیلتر) (.*)$','^(حذف فیلتر) (.*)$','^(خوشامد) (.*)$',"^(راهنما خصوصی)$",'^(تنظیم خوشامد) (.*)$'},
run=MaTaDoRTeaM,
pre_process = pre_processGroup
}