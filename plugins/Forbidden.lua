local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
local userid = tonumber(mr_roo[2])
local data = load_data(_config.moderation.data)
chat = msg.to.id
user = msg.from.id
if msg.to.type ~= 'pv' then
if (mr_roo[1]:lower() == "kick" or mr_roo[1] == "اخراج") and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="kick"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if userid == our_id then
			return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."*من نمیتوانم خودم رو از گروه اخراج کنم*"..EndPm, 0, "md")
		elseif is_mod1(msg.to.id, userid) then
			tdbot.sendMessage(msg.to.id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndPm, 0, "md")
		else
			kick_user(mr_roo[2], msg.to.id)
			sleep(1)
			channel_unblock(msg.to.id, mr_roo[2])
		end
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="kick"}))
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "delall" or mr_roo[1] == "حذف پیام") and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="delall"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if is_mod1(msg.to.id, userid) then
			return tdbot.sendMessage(msg.to.id, "", 0, M_START.."*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*"..EndPm, 0, "md")
		else
			tdbot.deleteMessagesFromUser(msg.to.id, mr_roo[2], dl_cb, nil)
			tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'تمامی پیام های '..mr_roo[2]..' پاک شد'..EndPm,17,string.len(mr_roo[2]))
		end
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="delall"}))
	end
end
--######################################################################--
end
if (mr_roo[1]:lower() == "banall" or mr_roo[1] == "سوپر مسدود") and is_admin(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="banall"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if userid == our_id then
			return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndPm, 0, "md")
		end
		if is_admin1(userid) then
			return tdbot.sendMessage(msg.to.id, "", 0, M_START.."*شما نمیتوانید ادمین های ربات رو از گروه های ربات محروم کنید*"..EndPm, 0, "md")
		end
		if is_gbanned(mr_roo[2]) then
			tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از گروه های ربات محروم بود'..EndPm,8,string.len(mr_roo[2]))
		end
		data['gban_users'][tostring(mr_roo[2])] = ""
		save_data(_config.moderation.data, data)
		kick_user(mr_roo[2], msg.to.id)
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از تمام گروه هار ربات محروم شد'..EndPm,8,string.len(mr_roo[2]))
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="banall"}))
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "unbanall" or mr_roo[1] == "حذف سوپر مسدود") and is_admin(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="unbanall"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if not is_gbanned(mr_roo[2]) then
			tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از گروه های ربات محروم نبود'..EndPm,8,string.len(mr_roo[2]))
		end
		data['gban_users'][tostring(mr_roo[2])] = nil
		save_data(_config.moderation.data, data)
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از محرومیت گروه های ربات خارج شد'..EndPm,8,string.len(mr_roo[2]))
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="unbanall"}))
	end
end
--######################################################################--
if msg.to.type ~= 'pv' then
if (mr_roo[1]:lower() == "ban" or mr_roo[1] == "مسدود") and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="ban"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if userid == our_id then
			return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndPm, 0, "md")
		end
		if is_mod1(msg.to.id, userid) then
			return tdbot.sendMessage(msg.to.id, "", 0, M_START.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو از گروه محروم کنید*"..EndPm, 0, "md")
		end
		if is_banned(mr_roo[2], msg.to.id) then
			tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از گروه محروم بود'..EndPm,8,string.len(mr_roo[2]))
		end
		data[tostring(chat)]['banned'][tostring(mr_roo[2])] = ""
		save_data(_config.moderation.data, data)
		kick_user(mr_roo[2], msg.to.id)
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,'کاربر '..mr_roo[2]..' از گروه محروم شد'..EndPm,8,string.len(mr_roo[2]))
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="ban"}))
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "unban"or mr_roo[1] == "حذف مسدود") and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="unban"}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		if not is_banned(mr_roo[2], msg.to.id) then
			tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از گروه محروم نبود'..EndPm,8,string.len(mr_roo[2]))
		end
		data[tostring(chat)]['banned'][tostring(mr_roo[2])] = nil
		save_data(_config.moderation.data, data)
		channel_unblock(msg.to.id, mr_roo[2])
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر  '..mr_roo[2]..' از محرومیت گروه خارج شد'..EndPm,8,string.len(mr_roo[2]))
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert(tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="unban"}))
end
end
--######################################################################--
if (mr_roo[1]:lower() == "silent" or mr_roo[1] == "سکوت") and is_mod(msg) and is_JoinChannel(msg) then
if not mr_roo[2] and msg.reply_id then
	assert(tdbot_function ({
	_ = "getMessage",
	chat_id = msg.to.id,
	message_id = msg.reply_id
	}, action_by_reply, {chat_id=msg.to.id,cmd="silent"}))
end
if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
	if userid == our_id then
		return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndPm, 0, "md")
	end
	if is_mod1(msg.to.id, userid) then
		return tdbot.sendMessage(msg.to.id, "", 0, M_START.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه و ادمین های ربات بگیرید*"..EndPm, 0, "md")
	end
	if is_silent_user(mr_roo[2], chat) then
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,'کاربر '..mr_roo[2]..' از قبل توانایی چت کردن رو نداشت'..EndPm,8,string.len(mr_roo[2]))
	end
	data[tostring(chat)]['is_silent_users'][tostring(mr_roo[2])] = ""
	save_data(_config.moderation.data, data)
	tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' توانایی چت کردن رو از دست داد'..EndPm,8,string.len(mr_roo[2]))
end
if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
	assert(tdbot_function ({
	_ = "searchPublicChat",
	username = mr_roo[2]
	}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="silent"}))
end
end
--######################################################################--
if (mr_roo[1]:lower() == "unsilent" or mr_roo[1] == "حذف سکوت") and is_mod(msg) and is_JoinChannel(msg) then
if not mr_roo[2] and msg.reply_id then
	assert(tdbot_function ({
	_ = "getMessage",
	chat_id = msg.to.id,
	message_id = msg.reply_id
	}, action_by_reply, {chat_id=msg.to.id,cmd="unsilent"}))
end
if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
	if not is_silent_user(mr_roo[2], chat) then
		tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' از قبل توانایی چت کردن رو داشت'..EndPm,8,string.len(mr_roo[2]))
	end
	data[tostring(chat)]['is_silent_users'][tostring(mr_roo[2])] = nil
	save_data(_config.moderation.data, data)
	tdbot.sendMention(msg.chat_id,mr_roo[2], msg.id,M_START..'کاربر '..mr_roo[2]..' توانایی چت کردن رو به دست آورد'..EndPm,8,string.len(mr_roo[2]))
end
if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
	assert(tdbot_function ({
	_ = "searchPublicChat",
	username = mr_roo[2]
	}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="unsilent"}))
end
end
--######################################################################--
if (mr_roo[1]:lower() == "clean" or mr_roo[1] == "پاک کردن") and is_owner(msg) then
if (mr_roo[2] == 'bans' or mr_roo[2] == 'لیست مسدود' ) and is_JoinChannel(msg) then
	if next(data[tostring(chat)]['banned']) == nil then
		return M_START.."*هیچ کاربری از این گروه محروم نشده*"..EndPm
	end
	for k,v in pairs(data[tostring(chat)]['banned']) do
		data[tostring(chat)]['banned'][tostring(k)] = nil
		save_data(_config.moderation.data, data)
	end
	return M_START.."*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"..EndPm
end
if (mr_roo[2] == 'silentlist' or mr_roo[2] == 'لیست سکوت' ) and is_JoinChannel(msg) then
	if next(data[tostring(chat)]['is_silent_users']) == nil then
		return M_START.."*لیست کاربران سایلنت شده خالی است*"..EndPm
	end
	for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
		data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
		save_data(_config.moderation.data, data)
	end
	return M_START.."*لیست کاربران سایلنت شده پاک شد*"..EndPm
end
end
--######################################################################--
end
if (mr_roo[1]:lower() == "clean" or mr_roo[1] == "پاک کردن") and is_sudo(msg) then
	if (mr_roo[2] == 'gbans' or mr_roo[2] == 'لیست سوپر مسدود' ) and is_JoinChannel(msg) then
		if next(data['gban_users']) == nil then
			return M_START.."*هیچ کاربری از گروه های ربات محروم نشده*"..EndPm
		end
		for k,v in pairs(data['gban_users']) do
			data['gban_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return M_START.."*تمام کاربرانی که از گروه های ربات محروم بودند از محرومیت خارج شدند*"..EndPm
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "gbanlist" or mr_roo[1] == "لیست سوپر مسدود") and is_admin(msg) and is_JoinChannel(msg) then
	return gbanned_list(msg)
end
--######################################################################--
if msg.to.type ~= 'pv' then
if (mr_roo[1]:lower() == "silentlist" or mr_roo[1] == "لیست سکوت") and is_mod(msg) and is_JoinChannel(msg) then
	return silent_users_list(chat)
end
--######################################################################--
if (mr_roo[1]:lower() == "banlist" or mr_roo[1] == "لیست مسدود") and is_mod(msg) and is_JoinChannel(msg) then
	return banned_list(chat)
end
--######################################################################--
end
end
return {
patterns = {"^[!/#](banall)$","^[!/#](banall) (.*)$","^[!/#](unbanall)$","^[!/#](unbanall) (.*)$","^[!/#](gbanlist)$","^[!/#](ban)$","^[!/#](ban) (.*)$","^[!/#](unban)$","^[!/#](unban) (.*)$","^[!/#](banlist)$","^[!/#](silent)$","^[!/#](silent) (.*)$","^[!/#](unsilent)$","^[!/#](unsilent) (.*)$","^[!/#](silentlist)$","^[!/#](kick)$","^[!/#](kick) (.*)$","^[!/#](delall)$","^[!/#](delall) (.*)$","^[!/#](clean) (.*)$","^([Bb]anall)$","^([Bb]anall) (.*)$","^([Uu]nbanall)$","^([Uu]nbanall) (.*)$","^([Gg]banlist)$","^([Bb]an)$","^([Bb]an) (.*)$","^([Uu]nban)$","^([Uu]nban) (.*)$","^([Bb]anlist)$","^([Ss]ilent)$","^([Ss]ilent) (.*)$","^([Uu]nsilent)$","^([Uu]nsilent) (.*)$","^([Ss]ilentlist)$","^([Kk]ick)$","^([Kk]ick) (.*)$","^([Dd]elall)$","^([Dd]elall) (.*)$","^([Cc]lean) (.*)$","^(سوپر مسدود)$","^(سوپر مسدود) (.*)$","^(حذف سوپر مسدود)$","^(حذف سوپر مسدود) (.*)$","^(لیست سوپر مسدود)$","^(مسدود)$","^(مسدود) (.*)$","^(حذف مسدود)$","^(حذف مسدود) (.*)$","^(لیست مسدود)$","^(سکوت)$","^(سکوت) (.*)$","^(حذف سکوت)$","^(حذف سکوت) (.*)$","^(لیست سکوت)$","^(اخراج)$","^(اخراج) (.*)$","^(حذف پیام)$","^(حذف پیام) (.*)$","^(پاک کردن) (.*)$"},
run = MaTaDoRTeaM,
pre_process = pre_processBan
}
