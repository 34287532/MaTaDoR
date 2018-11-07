local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if ((mr_roo[1]:lower() == "whitelist" ) or (mr_roo[1] == "لیست سفید" )) and mr_roo[2] == "+" and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[3] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="setwhitelist"})
	end
	if mr_roo[3] and string.match(mr_roo[3], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[3],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[3],cmd="setwhitelist"})
	end
	if mr_roo[3] and not string.match(mr_roo[3], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[3]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[3],cmd="setwhitelist"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "whitelist" ) or (mr_roo[1] == "لیست سفید" )) and mr_roo[2] == "-" and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[3] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="remwhitelist"})
	end
	if mr_roo[3] and string.match(mr_roo[3], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[3],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[3],cmd="remwhitelist"})
	end
	if mr_roo[3] and not string.match(mr_roo[3], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[3]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[3],cmd="remwhitelist"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "setowner" ) or (mr_roo[1] == 'مالک' )) and is_admin(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="setowner"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="setowner"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "remowner" ) or (mr_roo[1] == "حذف مالک" )) and is_admin(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="remowner"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="remowner"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "promote" ) or (mr_roo[1] == "مدیر" )) and is_owner(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="promote"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="promote"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="promote"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "demote" ) or (mr_roo[1] == "حذف مدیر" )) and is_owner(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd="demote"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="demote"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="demote"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "modlist" ) or (mr_roo[1] == "لیست مدیران" )) and is_mod(msg) and is_JoinChannel(msg) then
	return modlist(msg)
end
--######################################################################--
if ((mr_roo[1]:lower() == "ownerlist" ) or (mr_roo[1] == "لیست مالکان" )) and is_owner(msg) and is_JoinChannel(msg) then
	return ownerlist(msg)
end
--######################################################################--
if ((mr_roo[1]:lower() == "whitelist" ) or (mr_roo[1] == "لیست سفید" )) and not mr_roo[2] and is_mod(msg) and is_JoinChannel(msg) then
	return whitelist(msg)
end
--######################################################################--
end

return {
patterns ={"^[!/#](whitelist) ([+-])$","^[!/#](whitelist) ([+-]) (.*)$","^[#!/](whitelist)$","^[!/#](setowner)$","^[!/#](setowner) (.*)$","^[!/#](remowner)$","^[!/#](remowner) (.*)$","^[!/#](promote)$","^[!/#](promote) (.*)$","^[!/#](demote)$","^[!/#](demote) (.*)$","^[!/#](modlist)$","^[!/#](ownerlist)$","^([Ww]hitelist) ([+-])$","^([Ww]hitelist) ([+-]) (.*)$","^([Ww]hitelist)$","^([Ss]etowner)$","^([Ss]etowner) (.*)$","^([Rr]emowner)$","^([Rr]emowner) (.*)$","^([Pp]romote)$","^([Pp]romote) (.*)$","^([Dd]emote)$","^([Dd]emote) (.*)$","^([Mm]odlist)$","^([Oo]wnerlist)$",'^(لیست سفید) ([+-]) (.*)$','^(لیست سفید) ([+-])$','^(لیست سفید)$','^(مالک)$','^(مالک) (.*)$','^(حذف مالک) (.*)$','^(حذف مالک)$','^(مدیر)$','^(مدیر) (.*)$','^(حذف مدیر)$','^(حذف مدیر) (.*)$','^(لیست مالکان)$','^(لیست مدیران)$'},
run = MaTaDoRTeaM
}