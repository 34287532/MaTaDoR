function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if ((mr_roo[1]:lower() == 'clean' ) or (mr_roo[1] == 'پاک کردن' )) and is_owner(msg) then
if ((mr_roo[2]:lower() == 'blacklist' ) or (mr_roo[2] == 'لیست سیاه' )) and msg.to.type == "channel" and is_JoinChannel(msg) then
	local function GetRestricted(arg, data)
		if data.members then
			for k,v in pairs (data.members) do
				tdbot.changeChaargemberStatus(msg.to.id, v.user_id, 'Restricted', {1,0,1,1,1,1}, dl_cb, nil)
			end
		end
	end
	local function GetBlackList(arg, data)
		if data.members then
			for k,v in pairs (data.members) do
				channel_unblock(msg.to.id, v.user_id)
			end
		end
	end
	for i = 1, 2 do
		tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Restricted', GetRestricted, {msg=msg})
	end
	for i = 1, 2 do
		tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Banned', GetBlackList, {msg=msg})
	end
	return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`لیست سیاه گروه پاک سازی شد`"..EndPm, 0, "md")
end
--######################################################################--
if ((mr_roo[2]:lower() == 'bots' ) or (mr_roo[2] == 'ربات ها' )) and msg.to.type == "channel" and is_JoinChannel(msg) then
	local function GetBots(arg, data)
		if data.members then
			for k,v in pairs (data.members) do
				if not is_mod1(msg.to.id, v.user_id) then
					kick_user(v.user_id, msg.to.id)
				end
			end
		end
	end
	for i = 1, 5 do
		tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Bots', GetBots, {msg=msg})
	end
	return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`تمام ربات ها از گروه حذف شدند`"..EndPm, 0, "md")
end
--######################################################################--
if ((mr_roo[2]:lower() == 'deleted' ) or (mr_roo[2] == 'اکانت های دلیت شده' )) and msg.to.type == "channel" and is_JoinChannel(msg) then
	local function GetDeleted(arg, data)
		if data.members then
			for k,v in pairs (data.members) do
				local function GetUser(arg, data)
					if data.type and data.type._ == "userTypeDeleted" then
						kick_user(data.id, msg.to.id)
					end
				end
				tdbot.getUser(v.user_id, GetUser, {msg=arg.msg})
			end
		end
	end
	for i = 1, 2 do
		tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Recent', GetDeleted, {msg=msg})
	end
	for i = 1, 1 do
		tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Search', GetDeleted, {msg=msg})
	end
	return tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`تمام اکانت های دلیت ‌شده از گروه حذف شدند`"..EndPm, 0, "md")
end
--######################################################################--
end
end

return {
patterns={'^[/!#](clean) (.*)$','^([Cc]lean) (.*)$','^(پاک کردن) (.*)$'},
run = MaTaDoRTeaM
}
