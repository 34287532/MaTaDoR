local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if mr_roo[1]:lower() == "setrank"  and is_admin(msg) and is_JoinChannel(msg) then
	if msg.reply_id then
		assert (tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, rank_reply, {chat_id=msg.to.id,cmd="setrank",rank=string.sub(msg.text,9)}))
	elseif mr_roo[3] and string.match(mr_roo[3], '^%d+$') then
		assert (tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[3],
		}, rank_id, {chat_id=msg.to.id,user_id=mr_roo[3],cmd="setrank",rank=mr_roo[2]}))
	elseif mr_roo[3] and not string.match(mr_roo[3], '^%d+$') then
		assert (tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[3]
		}, rank_username, {chat_id=msg.to.id,username=mr_roo[3],cmd="setrank",rank=mr_roo[2]}))
	end
end
--######################################################################--
if mr_roo[1] == "تنظیم مقام"  and is_admin(msg) and is_JoinChannel(msg) then
	if msg.reply_id then
		assert (tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, rank_reply, {chat_id=msg.to.id,cmd="setrank",rank=string.sub(msg.text,21)}))
	elseif mr_roo[3] and string.match(mr_roo[3], '^%d+$') then
		assert (tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[3],
		}, rank_id, {chat_id=msg.to.id,user_id=mr_roo[3],cmd="setrank",rank=mr_roo[2]}))
	elseif mr_roo[3] and not string.match(mr_roo[3], '^%d+$') then
		assert (tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[3]
		}, rank_username, {chat_id=msg.to.id,username=mr_roo[3],cmd="setrank",rank=mr_roo[2]}))
	end
end
--######################################################################--
if (mr_roo[1] == "حذف مقام" or mr_roo[1]:lower() == "remrank" )  and is_admin(msg) and is_JoinChannel(msg) then
	if msg.reply_id then
		assert (tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, rank_reply, {chat_id=msg.to.id,cmd="delrank"}))
	elseif mr_roo[2] and string.match(mr_roo[2], '^%d+$') then
		assert (tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, rank_id, {chat_id=msg.to.id,user_id=mr_roo[2],cmd="delrank"}))
	elseif mr_roo[2] and not string.match(mr_roo[2], '^%d+$') then
		assert (tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, rank_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="delrank"}))
	end
end
--######################################################################--
if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return false end
--######################################################################--
if (mr_roo[1]:lower() == 'info' ) or (mr_roo[1] == 'اطلاعات' ) then
	if not mr_roo[2] and tonumber(msg.reply_to_message_id) ~= 0 then
		assert (tdbot_function ({
		_ = "getMessage",
		chat_id = msg.chat_id,
		message_id = msg.reply_to_message_id
		}, info_by_reply, {chat_id=msg.chat_id}))
	end
	if mr_roo[2] and string.match(mr_roo[2], '^%d+$') and tonumber(msg.reply_to_message_id) == 0 then
		assert (tdbot_function ({
		_ = "getUser",
		user_id = mr_roo[2],
		}, info_by_id, {chat_id=msg.chat_id,user_id=mr_roo[2],msgid=msg.id}))
	end
	if mr_roo[2] and not string.match(mr_roo[2], '^%d+$') and tonumber(msg.reply_to_message_id) == 0 then
		assert (tdbot_function ({
		_ = "searchPublicChat",
		username = mr_roo[2]
		}, info_by_username, {chat_id=msg.chat_id,username=mr_roo[2],msgid=msg.id}))
	end
	if not mr_roo[2] and tonumber(msg.reply_to_message_id) == 0 then
		local function info2_cb(arg, data)
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
				local text = M_START.."*نام :* `"..firstname.."`\n"..M_START.."*فامیلی :* `"..lastname.."`\n"..M_START.."*نام کاربری :* "..username.."\n"..M_START.."*آیدی :* `"..data.id.."`\n"
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
				user_info_msgs = tonumber(redis:get(RedisIndex..um_hash) or 0)
				text = text..M_START..'*پیام های گروه :* `'..gap_info_msgs..'`\n'
				text = text..M_START..'*پیام های کاربر :* `'..user_info_msgs..'`\n'
				text = text..M_START..'*درصد پیام کاربر :* `('..Percent..'%)`\n'
				text = text..M_START..'*وضعیت کاربر :* `'..UsStatus..'`\n'
				text = text..M_START..'*لقب کاربر :* `'..laghab..'`'
				tdbot.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
			end
		end
		assert (tdbot_function ({
		_ = "getUser",
		user_id = msg.sender_user_id,
		}, info_by_id, {chat_id=msg.chat_id,user_id=msg.sender_user_id,msgid=msg.id}))
	end
end
--######################################################################--
end

return {
patterns = {"^[!/#]([Ii]nfo)$","^[!/#]([Ii]nfo) (.*)$","^([Ii]nfo)$","^([Ii]nfo) (.*)$","^(اطلاعات)$","^(اطلاعات) (.*)$","^[/#!]([Ss]etrank) (.*) (.*)$","^[/#!]([Ss]etrank) (.*)$","^[/#!]([Rr]emrank)$","^[/#!]([Rr]emrank) (.*)$","^([Ss]etrank) (.*) (.*)$","^([Ss]etrank) (.*)$","^([Rr]emrank)$","^([Rr]emrank) (.*)$","^(تنظیم مقام) (.*) (.*)$","^(تنظیم مقام) (.*)$","^(حذف مقام)$","^(حذف مقام) (.*)$"},
run = MaTaDoRTeaM
}
