local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
	if (mr_roo[1]:lower() == 'setdow' or mr_roo[1] == 'تنظیم دانلود') and is_mod(msg) and is_JoinChannel(msg) then
		if redis:get(RedisIndex..'Num1Time:'..msg.to.id) and not is_admin(msg) then
			tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."`اجرای این دستور هر 1 ساعت یک بار ممکن است.`"..EndPm, 1, 'md')
		else
			redis:setex(RedisIndex..'Num1Time:'..msg.to.id, 3600, true)
			redis:setex(RedisIndex..'AutoDownload:'..msg.to.id, 1200, true)
			local text = M_START..'*با موفقیت ثبت شد.*\n`مدیران و صاحب گروه  میتواند به مدت 20 دقیقه از دستوراتی که نیاز به دانلود دارند استفاده کنند`\n*'..M_START..' نکته :* اجرای این دستور هر 1 ساعت یک بار ممکن است.'..EndPm
			tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
		end
	end
end

return {
patterns = {"^[!/#](setdow)$","^([Ss]etdow)$","^(تنظیم دانلود)$"},
run = MaTaDoRTeaM
}