--Begin Msg-Checks.lua By @MahDiRoO

local function Delall(msg)
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	if is_channel then
		del_msg(chat, tonumber(msg.id))
	elseif is_chat then
		kick_user(user, chat)
	end
end
local function Warnall(msg,fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local hashwarn = chat..':warn'
	local warnhash = redis:hget(RedisIndex..hashwarn, user) or 1
	local max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..chat) or 5)
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		if tonumber(warnhash) == tonumber(max_warn) then
			tdbot.sendMessage(chat, "", 0, M_START.."*کاربر* @"..check_markdown(msg.from.username or '').." `"..user.."` به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn.."\n*دلیل اخراج :* `ارسال "..fa.."`"..EndPm, 0, "md")
			kick_user(user, chat)
			redis:hdel(RedisIndex..hashwarn, user, '0')
		else
			redis:hset(RedisIndex..hashwarn, user, tonumber(warnhash) + 1)
			tdbot.sendMessage(chat, "", 0, M_START.."*کاربر* @"..check_markdown(msg.from.username or '').." `"..user.."` *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*\n*دلیل اخطار :* `ارسال "..fa.."`"..EndPm, 0, "md")
		end
	elseif is_chat then
		kick_user(user, chat)
	end
end
local function Silentall(msg,fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local timemutemsg = 3600
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		tdbot.Restricted(msg.chat_id,msg.sender_user_id,'Restricted',   {1,msg.date+timemutemsg, 0, 0, 0,0})
		tdbot.sendMessage(chat, "", 0, M_START.."*کاربر :*\n@"..check_markdown(msg.from.username or '').." `["..user.."]`\n*به مدت یک ساعت درحالت سکوت قرار گرفت*\n_دلیل سکوت :_ `"..fa.."`"..EndPm, 0, "md")
	elseif is_chat then
		kick_user(user, chat)
	end
end
local function Kickall(msg,fa)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		tdbot.sendMessage(chat, "", 0, M_START.."*کاربر :*\n@"..check_markdown(msg.from.username or '').." `["..user.."]`\n*از گروه اخراج شد*\n_ دلیل اخراج :_ `"..fa.."`"..EndPm, 0, "md")
		kick_user(user, chat)
		sleep(1)
		channel_unblock(user, chat)
	elseif is_chat then
		kick_user(user, chat)
	end
end
local function pre_process(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local data = load_data(_config.moderation.data)
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local is_chat = msg.to.type == "chat"
	local auto_leave = 'auto_leave_bot'
	if not redis:get(RedisIndex.."MaTaDoRLikes") then redis:set(RedisIndex.."MaTaDoRLikes",0) end
	if not redis:get(RedisIndex.."MaTaDoRDisLikes") then redis:set(RedisIndex.."MaTaDoRDisLikes",0) end
	if not redis:get(RedisIndex..'autodeltime') then
		redis:setex(RedisIndex..'autodeltime', 14400, true)
		run_bash("rm -rf ~/.telegram-bot/cli/data/stickers/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/photos/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/animations/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/videos/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/music/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/voice/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/temp/*")
		run_bash("rm -rf ~/.telegram-bot/cli/data/temp/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/documents/*")
		run_bash("rm -rf ~/.telegram-bot/cli/data/profile_photos/*")
		run_bash("rm -rf ~/.telegram-bot/cli/files/video_notes/*")
		run_bash("rm -rf ./data/photos/*")
	end
	if is_channel or is_chat then
		local TIME_CHECK = 2
		if data[tostring(chat)] then
			if data[tostring(chat)]['settings']['time_check'] then
				TIME_CHECK = tonumber(data[tostring(chat)]['settings']['time_check'])
			end
		end
		if msg.text then
			if msg.text:match("(.*)") then
				if not data[tostring(msg.to.id)] and not redis:get(RedisIndex..auto_leave) and not is_admin(msg) then
					tdbot.sendMessage(msg.to.id, "", 0, M_START.."*این گروه در لیست گروه های ربات ثبت نشده است !*\n`برای خرید ربات و اطلاعات بیشتر به ایدی زیر مراجعه کنید.`"..EndPm.."\n\n"..check_markdown(sudo_username).."", 0, "md")
					tdbot.changeChatMemberStatus(chat, our_id, 'Left', dl_cb, nil)
				end
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
		if msg.adduser or msg.joinuser or msg.deluser then
			if mute_tgservice == 'Enable' then
				del_msg(chat, tonumber(msg.id))
			end
		end
		if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
			if msg.adduser or msg.joinuser then
				if lock_join == 'Enable' then
					function join_kick(arg, data)
						kick_user(data.id, msg.to.id)
					end
					if msg.adduser then
						tdbot.getUser(msg.adduser, join_kick, nil)
					elseif msg.joinuser then
						tdbot.getUser(msg.joinuser, join_kick, nil)
					end
				end
			end
		end
		if msg.pinned and is_channel then
			if lock_pin == 'Enable' then
				if is_owner(msg) then
					return
				end
				if tonumber(msg.from.id) == our_id then
					return
				end
				local pin_msg = redis:get(RedisIndex..'pin_msg'..msg.chat_id)
				if pin_msg then
					tdbot.pinChannelMessage(msg.to.id, pin_msg, 1, dl_cb, nil)
				elseif not pin_msg then
					tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
					redis:del(RedisIndex..'pin_msg'..msg.chat_id)
				end
				tdbot.sendMessage(msg.to.id, msg.id, 0, M_START..'*آیدی کاربر :* `'..msg.from.id..'`\n*نام کاربری :* @'..check_markdown(msg.from.username or '')..'\n`شما اجازه دسترسی به سنجاق پیام را ندارید، به همین دلیل پیام قبلی مجدد سنجاق میگردد`'..EndPm, 0, "md")
			end
		end
		if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
			if msg.edited then
				if lock_edit == 'Enable' then Delall(msg) elseif lock_edit == 'Warn' then Warnall(msg,"ویرایش") elseif lock_edit == 'Mute' then Silentall(msg,"ویرایش") elseif lock_edit == 'Kick' then Kickall(msg,"ویرایش") end
			end
			if msg.lock_views ~= 0 then
				if lock_views == 'Enable' then Delall(msg) elseif lock_views == 'Warn' then Warnall(msg,"ویو") elseif lock_views == 'Mute' then Silentall(msg,"ویو") elseif lock_views == 'Kick' then Kickall(msg,"ویو") end
			end
			if msg.fwd_from_user or msg.fwd_from_channel then
				if mute_forward == 'Enable' then Delall(msg) elseif mute_forward == 'Warn' then Warnall(msg,"فوروارد") elseif mute_forward == 'Mute' then Silentall(msg,"فوروارد") elseif mute_forward == 'Kick' then Kickall(msg,"فوروارد") end
			end
			if msg.photo then
				if mute_photo == 'Enable' then Delall(msg) elseif mute_photo == 'Warn' then Warnall(msg,"عکس") elseif mute_photo == 'Mute' then Silentall(msg,"عکس") elseif mute_photo == 'Kick' then Kickall(msg,"عکس") end
			end
			if msg.video then
				if mute_video == 'Enable' then Delall(msg) elseif mute_video == 'Warn' then Warnall(msg,"فیلم") elseif mute_video == 'Mute' then Silentall(msg,"فیلم") elseif mute_video == 'Kick' then Kickall(msg,"فیلم") end
			end
			if msg.video_note then
				if mute_video_note == 'Enable' then Delall(msg) elseif mute_video_note == 'Warn' then Warnall(msg,"فیلم سلفی") elseif mute_video_note == 'Mute' then Silentall(msg,"فیلم سلفی") elseif mute_video_note == 'Kick' then Kickall(msg,"فیلم سلفی") end
			end
			if msg.document then
				if mute_document == 'Enable' then Delall(msg) elseif mute_document == 'Warn' then Warnall(msg,"فایل") elseif mute_document == 'Mute' then Silentall(msg,"فایل") elseif mute_document == 'Kick' then Kickall(msg,"فایل") end
			end
			if msg.sticker then
				if mute_sticker == 'Enable' then Delall(msg) elseif mute_sticker == 'Warn' then Warnall(msg,"استیکر") elseif mute_sticker == 'Mute' then Silentall(msg,"استیکر") elseif mute_sticker == 'Kick' then Kickall(msg,"استیکر") end
			end
			if msg.animation then
				if mute_gif == 'Enable' then Delall(msg) elseif mute_gif == 'Warn' then Warnall(msg,"گیف") elseif mute_gif == 'Mute' then Silentall(msg,"گیف") elseif mute_gif == 'Kick' then Kickall(msg,"گیف") end
			end
			if msg.contact then
				if mute_contact == 'Enable' then Delall(msg) elseif mute_contact == 'Warn' then Warnall(msg,"مخاطب") elseif mute_contact == 'Mute' then Silentall(msg,"مخاطب") elseif mute_contact == 'Kick' then Kickall(msg,"مخاطب") end
			end
			if msg.location then
				if mute_location == 'Enable' then Delall(msg) elseif mute_location == 'Warn' then Warnall(msg,"موقعیت مکانی") elseif mute_location == 'Mute' then Silentall(msg,"موقعیت مکانی") elseif mute_location == 'Kick' then Kickall(msg,"موقعیت مکانی") end
			end
			if msg.voice then
				if mute_voice == 'Enable' then Delall(msg) elseif mute_voice == 'Warn' then Warnall(msg,"ویس") elseif mute_voice == 'Mute' then Silentall(msg,"ویس") elseif mute_voice == 'Kick' then Kickall(msg,"ویس") end
			end
			if msg.content then
				if msg.reply_markup and  msg.reply_markup._ == "replyMarkupInlineKeyboard" then
					if mute_keyboard == 'Enable' then Delall(msg) elseif  mute_keyboard == 'Warn' then Warnall(msg,"کیبورد شیشه ای") elseif  mute_keyboard == 'Mute' then Silentall(msg,"کیبورد شیشه ای") elseif  mute_keyboard == 'Kick' then Kickall(msg,"کیبورد شیشه ای") end
				end
			end
			if tonumber(msg.via_bot_user_id) ~= 0 then
				if mute_inline == 'Enable' then Delall(msg) elseif mute_inline == 'Warn' then Warnall(msg,"دکمه شیشه ای") elseif mute_inline == 'Mute' then Silentall(msg,"دکمه شیشه ای") elseif mute_inline == 'Kick' then Kickall(msg,"دکمه شیشه ای") end
			end
			if msg.game then
				if mute_game == 'Enable' then Delall(msg) elseif mute_game == 'Warn' then Warnall(msg,"بازی") elseif mute_game == 'Mute' then Silentall(msg,"بازی") elseif mute_game == 'Kick' then Kickall(msg,"بازی") end
			end
			if msg.audio then
				if mute_audio == 'Enable' then Delall(msg) elseif mute_audio == 'Warn' then Warnall(msg,"آهنگ") elseif mute_audio == 'Mute' then Silentall(msg,"آهنگ") elseif mute_audio == 'Kick' then Kickall(msg,"آهنگ") end
			end
			if msg.media.caption then
				local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if link_caption and lock_link == 'Enable' then Delall(msg) elseif link_caption and lock_link == 'Warn' then Warnall(msg,"لینک") elseif link_caption and lock_link == 'Mute' then Silentall(msg,"لینک") elseif link_caption and lock_link == 'Kick' then Kickall(msg,"لینک") end
				local tag_caption = msg.media.caption:match("#")
				if tag_caption then
					if lock_tag == 'Enable' then Delall(msg) elseif lock_tag == 'Warn' then Warnall(msg,"تگ") elseif lock_tag == 'Mute' then Silentall(msg,"تگ") elseif lock_tag == 'Kick' then Kickall(msg,"تگ") end
				end
				local username_caption = msg.media.caption:match("@")
				if username_caption then
					if lock_username == 'Enable' then Delall(msg) elseif lock_username == 'Warn' then Warnall(msg,"تگ") elseif lock_username == 'Mute' then Silentall(msg,"تگ") elseif lock_username == 'Kick' then Kickall(msg,"تگ") end
				end
				if is_filter(msg, msg.media.caption) then
					Delall(msg)
				end
				local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
				if arabic_caption then
					if lock_arabic == 'Enable' then Delall(msg) elseif lock_arabic == 'Warn' then Warnall(msg,"فارسی") elseif lock_arabic == 'Mute' then Silentall(msg,"فارسی") elseif lock_arabic == 'Kick' then Kickall(msg,"فارسی") end
				end
			end
			if msg.text then
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
				local max_chars = 40
				if data[tostring(msg.to.id)] then
					if data[tostring(msg.to.id)]['settings']['set_char'] then
						max_chars = tonumber(data[tostring(msg.to.id)]['settings']['set_char'])
					end
				end
				local _nl, real_digits = string.gsub(msg.text, '%d', '')
				local max_real_digits = tonumber(max_chars) * 50
				local max_len = tonumber(max_chars) * 51
				if lock_spam == 'Enable' then
					if string.len(msg.text) > max_len or ctrl_chars > max_chars or real_digits > max_real_digits then
						Delall(msg)
					end
				end
				local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if link_msg then
					print('hi')
					if lock_link == 'Enable' then Delall(msg) elseif lock_link == 'Warn' then Warnall(msg,"لینک") elseif lock_link == 'Mute' then Silentall(msg,"لینک") elseif lock_link == 'Kick' then Kickall(msg,"لینک") end
				end
				local tag_msg = msg.text:match("#")
				if tag_msg then
					if lock_tag == 'Enable' then Delall(msg) elseif lock_tag == 'Warn' then Warnall(msg,"تگ") elseif lock_tag == 'Mute' then Silentall(msg,"تگ") elseif lock_tag == 'Kick' then Kickall(msg,"تگ") end
				end
				local username_msg = msg.text:match("@")
				if username_msg then
					if lock_username == 'Enable' then Delall(msg) elseif lock_username == 'Warn' then Warnall(msg,"نام کاربری") elseif lock_username == 'Mute' then Silentall(msg,"نام کاربری") elseif lock_username == 'Kick' then Kickall(msg,"نام کاربری") end
				end
				if is_filter(msg, msg.text) then
					Delall(msg)
				end
				local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
				if arabic_msg then
					if lock_arabic == 'Enable' then Delall(msg) elseif lock_arabic == 'Warn' then Warnall(msg,"فارسی") elseif lock_arabic == 'Mute' then Silentall(msg,"فارسی") elseif lock_arabic == 'Kick' then Kickall(msg,"فارسی") end
				end
				if msg.text:match("(.*)") then
					if mute_text == 'Enable'  then Delall(msg) elseif mute_text == 'Warn' then Warnall(msg,"متن") elseif mute_text == 'Mute' then Silentall(msg,"متن") elseif mute_text == 'Kick' then Kickall(msg,"متن") end
				end
			end
			if mute_all == 'Enable' then
				Delall(msg)
			end
			if msg.content and msg.content.entities then
				for k,entity in pairs(msg.content.entities) do
					if entity.type._ == "textEntityTypeMentionName" then
						if lock_mention == 'Enable' then Delall(msg) elseif lock_mention == 'Warn' then Warnall(msg,"منشن") elseif lock_mention == 'Mute' then Silentall(msg,"منشن") elseif lock_mention == 'Kick' then Kickall(msg,"منشن") end
					end
					if entity.type._ == "textEntityTypeUrl" or entity.type._ == "textEntityTypeTextUrl" then
						if lock_webpage == 'Enable' then Delall(msg) elseif lock_webpage == 'Warn' then Warnall(msg,"سایت") elseif lock_webpage == 'Mute' then Silentall(msg,"سایت") elseif lock_webpage == 'Kick' then Kickall(msg,"سایت") end
					end
					if msg.content and entity.type._ == "textEntityTypeBold" or entity.type._ == "textEntityTypeCode" or entity.type._ == "textEntityTypePre" or entity.type._ == "textEntityTypeItalic" then
						if lock_markdown == 'Enable' then Delall(msg) elseif lock_markdown == 'Warn' then Warnall(msg,"فونت") elseif lock_markdown == 'Mute' then Silentall(msg,"فونت") elseif lock_markdown == 'Kick' then Kickall(msg,"فونت") end
					end
				end
			end
			if msg.to.type ~= 'pv' then
				if lock_flood == 'Enable' and not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and not msg.adduser and msg.from.id ~= our_id then
					local hash = 'user:'..user..':msgs'
					local msgs = tonumber(redis:get(RedisIndex..hash) or 0)
					local NUM_MSG_MAX = 5
					if data[tostring(chat)] then
						if data[tostring(chat)]['settings']['num_msg_max'] then
							NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
						end
					end
					if msgs > NUM_MSG_MAX then
						if msg.from.username then
							user_name = "@"..msg.from.username
						else
							user_name = msg.from.first_name
						end
						if redis:get(RedisIndex..'sender:'..user..':flood') then
							return
						else
							del_msg(chat, msg.id)
							kick_user(user, chat)
							tdbot.sendMessage(chat, msg.id, 0, M_START.."*کاربر* `"..user.."` - "..user_name.." *به دلیل ارسال پیام های مکرر اخراج شد*"..EndPm, 0, "md")
							redis:setex(RedisIndex..'sender:'..user..':flood', 30, true)
						end
					end
					redis:setex(RedisIndex..hash, TIME_CHECK, msgs+1)
				end
			end
		end
	end
end
return {
patterns = {},
pre_process = pre_process
}
--End Msg-Checks.lua--