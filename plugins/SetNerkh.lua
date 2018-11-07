local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == 'setnerkh' or mr_roo[1] == 'تنظیم نرخ') and is_sudo(msg) then
	redis:set(RedisIndex..'nerkh',mr_roo[2])
	return M_START..'`متن شما با موفقیت تنظیم شد :`\n\n '..check_markdown(mr_roo[2])..''
end
--######################################################################--
if mr_roo[1] == 'تنظیم کارت' and is_sudo(msg) then
	redis:set(RedisIndex..'cart',mr_roo[2])
	return M_START..'`شماره کارت شما با موفقیت تنظیم شد :`\n\n '..check_markdown(mr_roo[2])..''
end
--######################################################################--
if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return false end
--######################################################################--
if mr_roo[1]:lower() == 'nerkh' or mr_roo[1] == 'نرخ' then
	local hash = ('nerkh')
	local nerkh = redis:get(RedisIndex..hash)
	if not nerkh then
		return M_START..'`نرخی برای ربات ثبت نشده است`'..EndPm
	else
		tdbot.sendMessage(msg.chat_id, msg.id, 1, check_markdown(nerkh), 1, 'md')
	end
end
--######################################################################--
if mr_roo[1] == 'شماره کارت' then
	local hash = ('cart')
	local cart = redis:get(RedisIndex..hash)
	if not cart then
		return M_START..'`شماره کارتی برای ربات ثبت نشده است`'..EndPm
	else
		tdbot.sendMessage(msg.chat_id, msg.id, 1, check_markdown(cart), 1, 'md')
	end
end
--######################################################################--
if mr_roo[1] == 'حذف شماره کارت' and is_sudo(msg) then
	local hash = ('cart')
	redis:del(RedisIndex..hash)
	return M_START..'`نرخ ربات پاک شد`'..EndPm
end
--######################################################################--
end

return {
patterns ={ "^[!#/](setnerkh) (.*)$", "^[!#/](nerkh)$","^[!#/](delnerkh)$", "^([Ss]etnerkh) (.*)$", "^([Nn]erkh)$","^([Dd]elnerkh)$","^(تنظیم نرخ) (.*)$", "^(نرخ)$","^(حذف نرخ)$","^(شماره کارت)$","^(حذف شماره کارت)$","^(تنظیم کارت) (.*)$"},
run = MaTaDoRTeaM
}