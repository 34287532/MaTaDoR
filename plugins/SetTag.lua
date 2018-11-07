function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == 'settag' ) or (mr_roo[1] == 'تنظیم تگ' ) and is_mod(msg) and is_JoinChannel(msg) then
	local title = mr_roo[2]
	local title2 = mr_roo[3]
	redis:set(RedisIndex..msg.to.id..'setmusictag', title)
	redis:set(RedisIndex..msg.to.id..'setmusictag2', title2)
	local text = M_START..'`تگ آهنگ تنظیم شد :`\n'..check_markdown(title)..'/'..check_markdown(title2)..''..EndPm
	return tdbot.sendMessage(msg.chat_id, 0, 1, text, 1, 'md')
end
--######################################################################--
if (mr_roo[1]:lower() == 'set' ) or (mr_roo[1] == 'تنظیم' ) and is_mod(msg) and is_JoinChannel(msg) then
	if not redis:get(RedisIndex..'AutoDownload:'..msg.to.id) then
		return M_START..'*دانلود خودکار در گروه شما فعال نمیباشد*'..EndPm..'\n*برای فعال سازی از دستور زیر استفاده کنید :*\n `"Setdow"` *&&* `"تنظیم دانلود"`'
	end
	local title = redis:get(RedisIndex..msg.to.id..'setmusictag')
	local title2 = redis:get(RedisIndex..msg.to.id..'setmusictag2')
	if not title and title2 then
		return tdbot.sendMessage(msg.chat_id, 0, 1, M_START..'`لطفا ابتدا تگ آهنگ را تنظیم کنید.`'..EndPm, 1, 'md')
	end
	if msg.reply_id  then
		function get_filemsg(arg, data)
			function get_fileinfo(arg,data)
				if data.content._ == 'messageAudio' then
					local audio_id = data.content.audio.audio.id
					local audio_name = data.content.audio.file_name
					local pathf = tcpath..'/files/music/'..audio_name
					local cpath = tcpath..'/files/music'
					if file_exi(audio_name, cpath) then
						local folder = 'data/photos/'..title..'.mp3'
						local pfile = folder
						os.rename(pathf, pfile)
						file_dl(audio_id)
					else
						tdbot.sendMessage(msg.chat_id, 0, 1, M_START..'`فایل را دوباره ارسال کنید`'..EndPm, 1, 'md')
					end
					local file = './data/photos/'..title..'.mp3'
					tdbot.sendAudio(msg.to.id, file, 0, title2, title , 1, M_START.."فایل ویرایش شده با تگ\n"..M_START..""..channel_username..""..EndPm)
				end
			end
			tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, get_fileinfo, nil)
		end
		tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_to_message_id }, get_filemsg, nil)
	end
end
--######################################################################--
end

return {
patterns = {"^[/#!]([Ss]ettag) (.*) (.*)$","^[/#!]([Ss]et)$","^([Ss]ettag) (.*) (.*)$","^([Ss]et)$","^(تنظیم تگ) (.*) (.*)$","^(تنظیم)$"},
run = MaTaDoRTeaM
}