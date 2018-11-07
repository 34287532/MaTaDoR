local function a_username(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local cmd = arg.cmd
	if not arg.username then return false end
	if data.id then
		if cmd == "id" then
			local function res_cb(arg, data)
				if not data.id then return end
				if data.first_name then
					user_name = check_markdown(data.first_name)
				end
				text = M_START.."*نام کاربری :* @"..check_markdown(data.username).."\n"..M_START.."*نام :* "..user_name.."\n"..M_START.."*ایدی :* `"..data.id.."`"
				return tdbot.sendMessage(arg.chat_id, "", 0, text, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.id
			}, res_cb, {chat_id=arg.chat_id,user_id=data.id})
		end
	end
end
--######################################################################--
local function MaTaDoRTeaMmr_roo(msg ,mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
--######################################################################--
if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return false end
--######################################################################--
if (mr_roo[1]:lower() == "id" ) or (mr_roo[1] == "ایدی" ) or (mr_roo[1] == "آیدی" ) then
	if mr_roo[2] and is_mod(msg) then
		if msg.content.entities[0].type._ == "textEntityTypeMentionName" then
			local function idmen(arg, data)
				if data.id then
					local user_name = lang and "NotFound" or "پیدا نشد"
					if data.username and data.username ~= "" then user_name = '@'..check_markdown(data.username) end
					local print_name = data.first_name
					if data.last_name and data.last_name ~= "" then print_name = print_name..' '..data.last_name end
					text = M_START.."*نام :* "..check_markdown(print_name).."\n"..M_START.."*ایدی :* `"..data.id.."`"
					return tdbot.sendMessage(msg.to.id, "", 0, text, 0, "md")
				end
			end
			tdbot.getUser(msg.content.entities[0].type.user_id, idmen)
		else
			tdbot_function ({
			_ = "searchPublicChat",
			username = mr_roo[2]
			}, a_username, {chat_id=msg.to.id,username=mr_roo[2],cmd="id"})
		end
	end
end
end

return {
patterns ={"^[!/#](id) (.*)$","^([Ii]d) (.*)$","^(ایدی) (.*)$","^(آیدی) (.*)$"},
run=MaTaDoRTeaM
}