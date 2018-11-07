local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == 'lock auto' or mr_roo[1] == 'قفل خودکار') and is_mod(msg)  and is_JoinChannel(msg) then
redis:setex(RedisIndex.."atolc"..msg.to.id..msg.sender_user_id,45,true)
if redis:get(RedisIndex.."atolct1"..msg.to.id) and redis:get(RedisIndex.."atolct2"..msg.to.id) then
	redis:del(RedisIndex.."atolct1"..msg.to.id)
	redis:del(RedisIndex.."atolct2"..msg.to.id)
	redis:del(RedisIndex.."lc_ato:"..msg.to.id)
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`زمان قبلی از سیستم حذف شد\n\nلطفا زمان شروع قفل خودکار را وارد کنید :\nمثال :\n 00:00`'..EndPm, 1, 'md')
else
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`لطفا زمان شروع قفل خودکار را وارد کنید :\nمثال :\n 15:24`'..EndPm, 1, 'md')
end
--######################################################################--
elseif (mr_roo[1]:lower() == 'unlock auto' or mr_roo[1] == 'باز کردن خودکار') and is_mod(msg) and is_JoinChannel(msg) then
if redis:get(RedisIndex.."atolct1"..msg.to.id) and redis:get(RedisIndex.."atolct2"..msg.to.id) then
	redis:del(RedisIndex.."atolct1"..msg.to.id)
	redis:del(RedisIndex.."atolct2"..msg.to.id)
	redis:del(RedisIndex.."lc_ato:"..msg.to.id)
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`زمانبدی ربات برای قفل کردن خودکار گروه حذف شد`'..EndPm, 1, 'md')
else
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`قفل خودکار از قبل غیرفعال بود`'..EndPm, 1, 'md')
end
--######################################################################--
elseif (mr_roo[1] == "00" or mr_roo[1] == "01" or mr_roo[1] == "02" or mr_roo[1] == "03" or mr_roo[1] == "04" or mr_roo[1] == "05" or mr_roo[1] == "06" or mr_roo[1] == "07" or mr_roo[1] == "08" or mr_roo[1] == "09" or mr_roo[1] == "10" or mr_roo[1] == "11" or mr_roo[1] == "12" or mr_roo[1] == "13" or mr_roo[1] == "14" or mr_roo[1] == "15" or mr_roo[1] == "16" or mr_roo[1] == "17" or mr_roo[1] == "18" or mr_roo[1] == "19" or mr_roo[1] == "20" or mr_roo[1] == "21" or mr_roo[1] == "22" or mr_roo[1] == "23") and (mr_roo[2] == "00" or mr_roo[2] == "01" or mr_roo[2] == "02" or mr_roo[2] == "03" or mr_roo[2] == "04" or mr_roo[2] == "05" or mr_roo[2] == "06" or mr_roo[2] == "07" or mr_roo[2] == "08" or mr_roo[2] == "09" or mr_roo[2] == "10" or mr_roo[2] == "11" or mr_roo[2] == "12" or mr_roo[2] == "13" or mr_roo[2] == "14" or mr_roo[2] == "15" or mr_roo[2] == "16" or mr_roo[2] == "17" or mr_roo[2] == "18" or mr_roo[2] == "19" or mr_roo[2] == "20" or mr_roo[2] == "21" or mr_roo[2] == "22" or mr_roo[2] == "23" or mr_roo[2] == "24" or mr_roo[2] == "25" or mr_roo[2] == "26" or mr_roo[2] == "27" or mr_roo[2] == "28" or mr_roo[2] == "29" or mr_roo[2] == "30" or mr_roo[2] == "31" or mr_roo[2] == "32" or mr_roo[2] == "33" or mr_roo[2] == "34" or mr_roo[2] == "35" or mr_roo[2] == "36" or mr_roo[2] == "37" or mr_roo[2] == "38" or mr_roo[2] == "39" or mr_roo[2] == "40" or mr_roo[2] == "41" or mr_roo[2] == "42" or mr_roo[2] == "43" or mr_roo[2] == "44" or mr_roo[2] == "45" or mr_roo[2] == "46" or mr_roo[2] == "47" or mr_roo[2] == "48" or mr_roo[2] == "49" or mr_roo[2] == "50" or mr_roo[2] == "51" or mr_roo[2] == "52" or mr_roo[2] == "53" or mr_roo[2] == "54" or mr_roo[2] == "55" or mr_roo[2] == "56" or mr_roo[2] == "57" or mr_roo[2] == "58" or mr_roo[2] == "59") and redis:get(RedisIndex.."atolc"..msg.to.id..msg.sender_user_id) and is_mod(msg) then
	tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`زمان شروع قفل خودکار در سیستم ثبت شد.\n\nلطفا زمان پایان قفل خودکار را وارد کنید :\nمثال :\n 07:00`'..EndPm, 1, 'md')
	redis:del(RedisIndex.."atolc"..msg.to.id..msg.sender_user_id)
	redis:setex(RedisIndex.."atolct1"..msg.to.id,45,mr_roo[1]..':'..mr_roo[2])
	redis:setex(RedisIndex.."atolc2"..msg.to.id..msg.sender_user_id,45,true)
--######################################################################--
elseif (mr_roo[1] == "00" or mr_roo[1] == "01" or mr_roo[1] == "02" or mr_roo[1] == "03" or mr_roo[1] == "04" or mr_roo[1] == "05" or mr_roo[1] == "06" or mr_roo[1] == "07" or mr_roo[1] == "08" or mr_roo[1] == "09" or mr_roo[1] == "10" or mr_roo[1] == "11" or mr_roo[1] == "12" or mr_roo[1] == "13" or mr_roo[1] == "14" or mr_roo[1] == "15" or mr_roo[1] == "16" or mr_roo[1] == "17" or mr_roo[1] == "18" or mr_roo[1] == "19" or mr_roo[1] == "20" or mr_roo[1] == "21" or mr_roo[1] == "22" or mr_roo[1] == "23") and (mr_roo[2] == "00" or mr_roo[2] == "01" or mr_roo[2] == "02" or mr_roo[2] == "03" or mr_roo[2] == "04" or mr_roo[2] == "05" or mr_roo[2] == "06" or mr_roo[2] == "07" or mr_roo[2] == "08" or mr_roo[2] == "09" or mr_roo[2] == "10" or mr_roo[2] == "11" or mr_roo[2] == "12" or mr_roo[2] == "13" or mr_roo[2] == "14" or mr_roo[2] == "15" or mr_roo[2] == "16" or mr_roo[2] == "17" or mr_roo[2] == "18" or mr_roo[2] == "19" or mr_roo[2] == "20" or mr_roo[2] == "21" or mr_roo[2] == "22" or mr_roo[2] == "23" or mr_roo[2] == "24" or mr_roo[2] == "25" or mr_roo[2] == "26" or mr_roo[2] == "27" or mr_roo[2] == "28" or mr_roo[2] == "29" or mr_roo[2] == "30" or mr_roo[2] == "31" or mr_roo[2] == "32" or mr_roo[2] == "33" or mr_roo[2] == "34" or mr_roo[2] == "35" or mr_roo[2] == "36" or mr_roo[2] == "37" or mr_roo[2] == "38" or mr_roo[2] == "39" or mr_roo[2] == "40" or mr_roo[2] == "41" or mr_roo[2] == "42" or mr_roo[2] == "43" or mr_roo[2] == "44" or mr_roo[2] == "45" or mr_roo[2] == "46" or mr_roo[2] == "47" or mr_roo[2] == "48" or mr_roo[2] == "49" or mr_roo[2] == "50" or mr_roo[2] == "51" or mr_roo[2] == "52" or mr_roo[2] == "53" or mr_roo[2] == "54" or mr_roo[2] == "55" or mr_roo[2] == "56" or mr_roo[2] == "57" or mr_roo[2] == "58" or mr_roo[2] == "59") and redis:get(RedisIndex.."atolc2"..msg.to.id..msg.sender_user_id) and is_mod(msg) then
	local time_1 = redis:get(RedisIndex.."atolct1"..msg.to.id)
	if time_1 == mr_roo[1]..':'..mr_roo[2] then
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`آغاز قفل خودکار نمیتوانید با پایان آن یکی باشد`'..EndPm, 1, 'md')
	else
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`عملیات با موقیت انجام شد.\n\nگروه شما در ساعت` *'..time_1..'* `الی` *'..mr_roo[1]..':'..mr_roo[2]..'* `بصورت خودکار تعطیل خواهد شد.`'..EndPm, 1, 'md')
		redis:set(RedisIndex.."atolct1"..msg.to.id,redis:get(RedisIndex.."atolct1"..msg.to.id))
		redis:set(RedisIndex.."atolct2"..msg.to.id,mr_roo[1]..':'..mr_roo[2])
		redis:del(RedisIndex.."atolc2"..msg.to.id..msg.sender_user_id)
	end
end
if (mr_roo[1]:lower() == 'time sv' or mr_roo[1] == 'ساعت سرور') and is_sudo(msg)then
tdbot.sendMessage(msg.to.id, msg.id, 1, M_START..'`ساعت سرور :`\n'..os.date("%H:%M:%S")..''..EndPm, 1, 'md')
end
--######################################################################--
end

return {
patterns = {"^[/!#]([sS][eE][rR][vV][eE][rR] [tT][iI][mM][eE])$","^[/!#]([Tt]ime sv)$","^([Tt]ime sv)$","^[/!#]([lL][oO][cC][kK] [aA][uU][tT][oO])$","^[/!#]([uU][nN][lL][oO][cC][kK] [aA][uU][tT][oO])$","^([sS][eE][rR][vV][eE][rR] [tT][iI][mM][eE])$","^([lL][oO][cC][kK] [aA][uU][tT][oO])$","^([uU][nN][lL][oO][cC][kK] [aA][uU][tT][oO])$","^(قفل خودکار)$","^(ساعت سرور)$","^(باز کردن خودکار)$","^(%d+):(%d+)$"},
run = MaTaDoRTeaM,
pre_process = pre_processAuto
}