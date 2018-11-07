local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == "setmonshi" or mr_roo[1] == "تنظیم منشی") and is_sudo(msg) then
	local pm = mr_roo[2]
	redis:set(RedisIndex..'bot:pm',pm)
	return M_START..'`متن منشی با موفقیت ثبت شد.`\n\n>>>  '..check_markdown(pm)..''
end
--######################################################################--
if (mr_roo[1]:lower() == "monshi" or mr_roo[1] == "منشی") and not mr_roo[2] and is_sudo(msg) then
	local hash = ('bot:pm')
	local pm = redis:get(RedisIndex..hash)
	if not pm then
		return M_START..'`متن منشی ثبت نشده است.`'..EndPm
	else
		return tdbot.sendMessage(msg.chat_id, 0, 1, "*پیغام کنونی منشی :*\n\n"..check_markdown(pm), 0, 'md')
	end
end
--######################################################################--
if (mr_roo[1]:lower() == "monshi" or mr_roo[1] == "منشی") and is_sudo(msg) then
	if mr_roo[2]=="on" or mr_roo[2]=="فعال" then
		redis:set(RedisIndex.."bot:pm", M_START.."`سلام من یک اکانت هوشمند هستم.`"..EndPm )
		return M_START.."`منشی فعال شد لطفا دوباره پیغام را تنظیم کنید`" ..EndPm
	end
	if mr_roo[2]=="off" or mr_roo[2]=="غیرفعال" then
		redis:del(RedisIndex.."bot:pm")
		return M_START.."`منشی غیرفعال شد`" ..EndPm
	end
end
--######################################################################--
end

return {
patterns ={ "^[!#/](setmonshi) (.*)$","^[!#/](monshi) (on)$", "^[!#/](monshi) (off)$","^[!#/](monshi)$","^([Ss]etmonshi) (.*)$", "^([Mm]onshi) (on)$", "^([Mm]onshi) (off)$", "^([Mm]onshi)$","^(تنظیم منشی) (.*)$", "^(منشی) (فعال)$", "^(منشی) (غیرفعال)$","^(منشی)$"},
run = MaTaDoRTeaM,
pre_process = pre_processMon
}
