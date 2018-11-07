function MaTaDoRTeaM(msg,mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == 'clean msgs' or mr_roo[1] == 'پاکسازی پیام ها') and is_owner(msg) and is_JoinChannel(msg)  then
	local function pro(arg,data)
		for k,v in pairs(data.members) do
			tdbot.deleteMessagesFromUser(msg.chat_id, v.user_id, dl_cb, nil)
		end
	end
	local function cb(arg,data)
		for k,v in pairs(data.messages) do
			del_msg(msg.chat_id, v.id)
		end
	end
	for i = 1, 5 do
		tdbot.getChatHistory(msg.to.id, msg.id, 0,  500000000, 0, cb, nil)
	end
	for i = 1, 2 do
		tdbot.getChannelMembers(msg.to.id, 0, 50000, "Search", pro, nil)
	end
	for i = 1, 1 do
		tdbot.getChannelMembers(msg.to.id, 0, 50000, "Recent", pro, nil)
	end
	for i = 1, 5 do
		tdbot.getChannelMembers(msg.to.id, 0, 50000, "Banned", pro, nil)
	end
	return M_START.."*درحال پاکسازی پیام های گروه*"..EndPm
end
--######################################################################--
if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return false end
--######################################################################--
if (mr_roo[1]:lower() == 'mydel' ) or (mr_roo[1] == 'پاکسازی پیام های من' ) then
	tdbot.deleteMessagesFromUser(msg.to.id,  msg.sender_user_id, dl_cb, nil)
	return M_START.."*پیام های کاربر :*\n[@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]\n *پاکسازی شد توسط خودش*"..EndPm
end
--######################################################################--
if ((mr_roo[1]:lower() == "del" ) or (mr_roo[1] == "حذف" ))  and tonumber(msg.reply_to_message_id) ~= 0 and is_mod(msg) and is_JoinChannel(msg) then
	del_msg(msg.to.id, msg.reply_id)
	del_msg(msg.to.id, msg.id)
end
--######################################################################--
if ((mr_roo[1]:lower() == 'rmsg' ) or (mr_roo[1] == 'پاکسازی' )) and is_mod(msg) and is_JoinChannel(msg) then
	if tonumber(mr_roo[2]) > 100 then
		tdbot.sendMessage(msg.chat_id,  msg.id, 0, M_START.."*عددی بین * [`1-100`] را انتخاب کنید"..EndPm, 0, "md")
	else
		local function cb(arg,data)
			for k,v in pairs(data.messages) do
				del_msg(msg.chat_id, v.id)
			end
		end
		tdbot.getChatHistory(msg.to.id, msg.id, 0,  mr_roo[2], 0, cb, nil)
		tdbot.sendMessage(msg.chat_id,  msg.id, 0, M_START.."`تعداد` *("..mr_roo[2]..")* `پیام پاکسازی شد`"..EndPm, 0, "md")
	end
end
--######################################################################--
end

return {
patterns = {"^[!/#](clean msgs)$","^([Cc]lean msgs)$","^[!/#](mydel)$","^([Mm]ydel)$","^[!/#](del)$","^([Dd]el)$","^[!/#](rmsg) (%d+)$","^([Rr]msg) (%d+)$","^(پاکسازی پیام ها)$","^(پاکسازی پیام های من)$","^(حذف)$","^(پاکسازی) (%d+)$"},
run = MaTaDoRTeaM
}

