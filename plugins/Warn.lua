local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if ((mr_roo[1]:lower() == 'clean' and mr_roo[2] == 'warns' ) or (mr_roo[1] == "پاک کردن" and mr_roo[2] == 'اخطار ها' )) and is_JoinChannel(msg) then
	if not is_owner(msg) then
		return
	end
	local hash = msg.to.id..':warn'
	redis:del(RedisIndex..hash)
	return M_START.."`تمام اخطار های کاربران این گروه پاک شد`"..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == 'setwarn' ) or (mr_roo[1] == "حداکثر اخطار" )) and is_JoinChannel(msg) then
	if not is_mod(msg) then
		return
	end
	if tonumber(mr_roo[2]) < 1 or tonumber(mr_roo[2]) > 20 then
		return M_START.."`لطفا عددی بین [1-20] را انتخاب کنید`"..EndPm
	end
	local warn_max = mr_roo[2]
	redis:set(RedisIndex..'max_warn:'..msg.to.id, warn_max)
	return M_START.."`حداکثر اخطار تنظیم شد به :` *[ "..mr_roo[2].." ]*"..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == "warn" ) or (mr_roo[1] == "اخطار" )) and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,msg=msg,cmd="warn"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') and not msg.reply_id then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],msg=msg,cmd="warn"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') and not msg.reply_id then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],msg=msg,cmd="warn"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "unwarn" ) or (mr_roo[1] == "حذف اخطار" )) and is_mod(msg) and is_JoinChannel(msg) then
	if not mr_roo[2] and msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,msg=msg,cmd="unwarn"})
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') and not msg.reply_id then
		tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, action_by_id, {chat_id=msg.to.id,user_id=mr_roo[2],msg=msg,cmd="unwarn"})
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') and not msg.reply_id then
		tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, action_by_username, {chat_id=msg.to.id,username=mr_roo[2],msg=msg,cmd="unwarn"})
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "warnlist" ) or (mr_roo[1] == "لیست اخطار" )) and is_mod(msg) and is_JoinChannel(msg) then
	local list = M_START..'لیست اخطار :\n'
	local empty = list
	for k,v in pairs (redis:hkeys(RedisIndex..msg.to.id..':warn')) do
		local user_name = redis:get(RedisIndex..'user_name:'..v)
		local cont = redis:hget(RedisIndex..msg.to.id..':warn', v)
		if user_name then
			list = list..k..'- '..check_markdown(user_name)..' [`'..v..'`] \n*اخطار : '..(cont - 1)..'*\n'
		else
			list = list..k..'- `'..v..'` \n*اخطار : '..(cont - 1)..'*\n'
		end
	end
	if list == empty then
		return M_START..'*لیست اخطار خالی است*'..EndPm
	else
		return list
	end
end
--######################################################################--
end

local function pre_process(msg)
	if tonumber(msg.from.id) ~= 0 then
		local hash = 'user_name:'..msg.from.id
		if msg.from.username then
			user_name = '@'..msg.from.username
		else
			user_name = msg.from.print_name
		end
		redis:set(RedisIndex..hash, user_name)
	end
end

return {
patterns = {"^[#!/](warn)$","^[#!/](warn) (.*)$","^[#!/](unwarn)$","^[#!/](unwarn) (.*)$","^[!/#](setwarn) (%d+)$","^[#!/](clean) (warns)$","^[#!/](warnlist)$","^([Ww]arn)$","^([Ww]arn) (.*)$","^([Uu]nwarn)$","^([Uu]nwarn) (.*)$","^([Ss]etwarn) (%d+)$","^([Cc]lean) (warns)$","^([Ww]arnlist)$","^(اخطار)$","^(اخطار) (.*)$","^(حذف اخطار)$","^(حذف اخطار) (.*)$","^(حداکثر اخطار) (%d+)$","^(پاک کردن) (اخطار ها)$","^(لیست اخطار)$"},
run = MaTaDoRTeaM,
pre_process = pre_process
}