local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if (mr_roo[1]:lower() == "paneladd" or mr_roo[1] == "پنل اد اجباری") and is_mod(msg) and is_JoinChannel(msg) then
	local function inline_query_cb(arg, data)
		if data.results and data.results[0] then
			redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.to.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
		else
			text = M_START.."مشکل فنی در ربات هلپر"..EndPm
			return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
		end
	end
	tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.to.id, 0, 0, "Addl:"..msg.to.id, 0, inline_query_cb, nil)
end
--######################################################################--
if (mr_roo[1]:lower() == "paneladdpv" or mr_roo[1] == "پنل اد اجباری خصوصی") and is_mod(msg) and not mr_roo[2] and is_JoinChannel(msg) then
	if not redis:get(RedisIndex..msg.from.id..'chkusermonshi') and not is_sudo(msg) then
		tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."`شما برای اجرای این دستور ابتدا باید خصوصی ربات پیام دهید.`"..EndPm, 1, 'md')
	else
		local function inline_query_cb(arg, data)
			if data.results and data.results[0] then
				redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id .. ":" .. msg.from.id, 260, true) redis:setex(RedisIndex.."ReqMenu:" .. msg.to.id, 10, true) tdbot.sendInlineQueryResultMessage(msg.from.id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
			else
				text = M_START.."مشکل فنی در ربات هلپر"..EndPm
				return tdbot.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
			end
		end
		tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.from.id, 0, 0, "Addl:"..msg.to.id, 0, inline_query_cb, nil)
		tdbot.sendMessage(msg.to.id, msg.id, 0, M_START.."`پنل اد اجباری به خصوصی شما ارسال شد.`"..EndPm, 0, "md")
	end
end
end

return {
patterns = {'^[!/#](paneladd)$','^[!/#](paneladdpv)$','^([Pp]aneladd)$','^([Pp]aneladdpv)$','^(پنل اد اجباری)$','^(پنل اد اجباری خصوصی)$'},
run = MaTaDoRTeaM,
pre_process = pre_processLim
}