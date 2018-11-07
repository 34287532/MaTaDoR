package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'.. ';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
tdbot = dofile('./libs/tdbot.lua')
serpent = (loadfile "./libs/serpent.lua")()
feedparser = (loadfile "./libs/feedparser.lua")()
require('./bot/Info-Bot')
require('./bot/Utils')
require('./bot/Function')
require('./libs/lua-redis')
URL = require "socket.url"
http = require "socket.http"
https = require "ssl.https"
ltn12 = require "ltn12"
json = (loadfile "./libs/JSON.lua")()
mimetype = (loadfile "./libs/mimetype.lua")()
redis = (loadfile "./libs/redis.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
chats = {}
plugins = {}
local bot_profile = 'cli'
--######################################################################--
function do_notify (user, msg)
	local n = notify.Notification.new(user, msg)
	n:show ()
end
--######################################################################--
function serpdump(value)
	print(serpent.block(value, {comment=false}))
end
--######################################################################--
function vardump(value, depth, key)
	local linePrefix = ""
	local spaces = ""
	if key ~= nil then
		linePrefix = ""..key.." = "
	end
	if depth == nil then
		depth = 0
	else
		depth = depth + 1
		for i=1, depth do
			spaces = spaces .. "  "
		end
	end
	if type(value) == 'table' then
		mTable = getmetatable(value)
		if mTable == nil then
			print(spaces ..linePrefix.." (table)")
		else
			print(spaces .."(metatable) ")
			value = mTable
		end
		for tableKey, tableValue in pairs(value) do
			vardump(tableValue, depth, tableKey)
		end
	elseif type(value)  == 'function' or type(value) == 'thread' or type(value) == 'userdata' or value == nil then
		print(spaces..tostring(value))
	else
		print(spaces..linePrefix..tostring(value))
	end
end
--######################################################################--
function load_data(filename)
	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)
	return data
end
--######################################################################--
function save_data(filename, data)
	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end
--######################################################################--
function whoami()
	local usr = io.popen("whoami"):read('*a')
	usr = string.gsub(usr, '^%s+', '')
	usr = string.gsub(usr, '%s+$', '')
	usr = string.gsub(usr, '[\n\r]+', ' ')
	if usr:match("^root$") then
		tcpath = '/root/.telegram-bot/'..bot_profile
	elseif not usr:match("^root$") then
		tcpath = '/home/'..usr..'/.telegram-bot/'..bot_profile
	end
end
--######################################################################--
function match_plugins(msg)
	for name, plugin in pairs(plugins) do
		match_plugin(plugin, name, msg)
	end
end
--######################################################################--
function save_config( )
	serialize_to_file(_config, './data/config.lua')
	print ('saved config into ./data/config.lua')
end
--######################################################################--
function create_config( )
	config = {
	enabled_plugins = {
	"Administrative",
	"AutoDownload",
	"Auto-Lock",
	"Clean-Msg",
	"Forbidden",
	"Fun",
	"GroupManager",
	"Info-Pro",
	"Lock-Pro",
	"Limitmember",
	"Monshi-Bot",
	"Msg-Checks",
	"Practical",
	"SetUp-Plugins",
	"SetTag",
	"Warn",
	"Mod-Set",
	"Helper-Api",
	"Id",
	"Help-Api",
	"SetNerkh",
	"Limitmember-Helper"
	},
	enabled_plugins_api = {
	"Helper-Api",
	"Help-Api",
	"Limitmember-Helper"
	},
	sudo_users = {464555636,SUDO,BotMaTaDoR_id,BotMaTaDoR_idapi},
	admins = {},
	disabled_channels = {},
	moderation = {data = './data/moderation.json'},
	}
	serialize_to_file(config, './data/config.lua')
	print ('saved config into config.lua')
end
--######################################################################--
function load_config( )
	local f = io.open('./data/config.lua', "r")
	if not f then
		print ("Created new config file: ./data/config.lua")
		create_config()
	else
		f:close()
	end
	local config = loadfile ("./data/config.lua")()
	for v,user in pairs(config.sudo_users) do
		print("➥ Sudo User : ( " .. user.. " )\n")
	end
	return config
end
--######################################################################--
whoami()
--######################################################################--
_config = load_config()
--######################################################################--
function load_plugins()
	local config = loadfile ("./data/config.lua")()
	print("➥ Plugin List :")
	for k, v in pairs(config.enabled_plugins) do
		print("⋆ "..v.."")
		local ok, err =  pcall(function()
			local t = loadfile("plugins/"..v..'.lua')()
			plugins[v] = t
		end)
		if not ok then end
	end
	for k, v in pairs(_config.enabled_plugins_api) do
		local ok, err =  pcall(function()
			local t = loadfile("plugins/"..v..".lua")()
			plugins[v] = t
		end)
		if not ok then end
	end
	print('MaTaDoR Version 8.5')
end
--######################################################################--
load_plugins()
--######################################################################--
local function action_by_reply(arg, data)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local cmd = arg.cmd
	if not tonumber(data.sender_user_id) then return false end
	if data.sender_user_id then
		if cmd == "id" then
			local function id_cb(arg, data)
				if data.first_name then
					user_name = check_markdown(data.first_name)
				end
				text = M_START.."*نام کاربری :* @"..check_markdown(data.username).."\n"..M_START.."*نام :* "..user_name.."\n"..M_START.."*ایدی :* `"..data.id.."`"
				return tdbot.sendMessage(arg.chat_id, "", 0, text, 0, "md")
			end
			tdbot_function ({
			_ = "getUser",
			user_id = data.sender_user_id
			}, id_cb, {chat_id=data.chat_id,user_id=data.sender_user_id})
		end
	end
end
--######################################################################--
function is_JoinChannel(msg)
	local url  = https.request('https://api.telegram.org/bot'..bot_token..'/getchatmember?chat_id=@'..channel_inline..'&user_id='..msg.sender_user_id)
	if res ~= 200 then end
	Joinchanel = json:decode(url)
	if (not Joinchanel.ok or Joinchanel.result.status == "left" or Joinchanel.result.status == "kicked") and not is_sudo(msg) then
		local function inline_query_cb(arg, data)
			if data.results and data.results[0] then
				tdbot.sendInlineQueryResultMessage(msg.chat_id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
			end
		end
		tdbot.getInlineQueryResults(BotMaTaDoR_idapi, msg.chat_id, 0, 0, "Join", 0, inline_query_cb, nil)
	else
		return true
	end
end
--######################################################################--
function msg_valid(msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if msg.date and msg.date < os.time() - 60 then
		print('\27[36m'..M_START..'Old Message'..EndPm..'\27[39m')
		return false
	end
	local matches = msg.content.text
	if matches then
		matches = matches:lower()
	end
	if matches then
		if matches:match('^[/#!]') then
			matches= matches:gsub('^[/#!]','')
		end
	end
	if (matches == "ping" ) or (matches == "انلاینی" ) or (matches == "آنلاینی" ) then
		if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return else
			tdbot.sendMention(msg.chat_id,msg.sender_user_id, msg.id,M_START..'ربات آنلاین و آماده به کار است'..EndPm,7, tonumber(Slen("آنلاین")))
		end
	end
	if (matches == "id"  or matches == "ایدی" or matches == "آیدی") and tonumber(msg.reply_to_message_id) == 0 then
		if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return else
		local function getpro(arg, data)
		local user_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..msg.sender_user_id..':'..msg.chat_id) or 0)
		local gap_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..msg.chat_id) or 0)
			if not data.photos[0] then
				tdbot.sendMessage(msg.chat_id, msg.id, 1, M_START.."*شناسه گروه :* `"..msg.chat_id.."`\n"..M_START.."*شناسه شما :* `"..msg.sender_user_id.."`", 1, 'md')
			else
				tdbot.sendPhoto(msg.chat_id, msg.id, data.photos[0].sizes[1].photo.persistent_id, 0, {}, 0, 0, ''..M_START..'شناسه گروه : '..msg.chat_id..'\n'..M_START..'شناسه شما : '..msg.sender_user_id..'\n'..M_START..'تعداد پیام های گروه : [ '..gap_info_msgs..' ]\n'..M_START..'تعداد پیام های شما : [ '..user_info_msgs..' ]', 0, 0, 1, nil, dl_cb, nil)
			end
		end
		assert(tdbot_function ({
		_ = "getUserProfilePhotos",
		user_id = msg.sender_user_id,
		offset = 0,
		limit = 1
		}, getpro, nil))
		end
	end
	if (matches == "id" or matches == "ایدی" or matches == "آیدی") and tonumber(msg.reply_to_message_id) ~= 0 and is_mod(msg) then
		if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return else
		assert(tdbot_function ({
		_ = "getMessage",
		chat_id = msg.chat_id,
		message_id = msg.reply_to_message_id
		}, action_by_reply, {chat_id=msg.chat_id,cmd="id"}))
		end
	end
	if is_silent_user((msg.sender_user_id or 0), msg.chat_id) then
		del_msg(msg.chat_id, msg.id)
		return false
	end
	if is_banned((msg.sender_user_id or 0), msg.chat_id) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
		return false
	end
	if is_gbanned((msg.sender_user_id or 0)) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
		return false
	end
	return true
end
--######################################################################--
function match_pattern(pattern, text, lower_case)
	if text then
		local matches = {}
		if lower_case then
			matches = { string.match(text:lower(), pattern) }
		else
			matches = { string.match(text, pattern) }
		end
		if next(matches) then
			return matches
		end
	end
end
--######################################################################--
local function is_plugin_disabled_on_chat(plugin_name, receiver)
	local disabled_chats = _config.disabled_plugin_on_chat
	if disabled_chats and disabled_chats[receiver] then
		for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
			if disabled_plugin == plugin_name and disabled then
				return true
			end
		end
	end
	return false
end
--######################################################################--
function match_plugin(plugin, plugin_name, msg)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	if plugin.pre_process then
		local result = plugin.pre_process(msg)
		if result then
			print("pre process: ", plugin_name)
		end
	end
	for k, pattern in pairs(plugin.patterns) do
		matches = match_pattern(pattern, msg.text  or msg.media.caption)
		if matches then
			if is_plugin_disabled_on_chat(plugin_name, msg.chat_id) then
				return nil
			end
			print(M_START.."Message matches: ", pattern..' | Plugin: '..plugin_name..EndPm)
			if plugin.run then
				if not warns_user_not_allowed(plugin, msg) then
					local result = plugin.run(msg, matches)
					if result then
						tdbot.sendText(msg.chat_id, msg.id, result, 0, 1, nil, 0, 'md', 0, nil)
					end
				end
			end
			return
		end
	end
end
--######################################################################--
function file_cb(msg)
	if msg.content._ == "messagePhoto" then
		photo_id = ''
		local function get_cb(arg, data)
			if data.content then
				if data.content.photo.sizes[2] then
					photo_id = data.content.photo.sizes[2].photo.id
				else
					photo_id = data.content.photo.sizes[1].photo.id
				end
				tdbot.downloadFile(photo_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageVideo" then
		video_id = ''
		local function get_cb(arg, data)
			if data.content then
				video_id = data.content.video.video.id
				tdbot.downloadFile(video_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageAnimation" then
		anim_id, anim_name = '', ''
		local function get_cb(arg, data)
			if data.content then
				anim_id = data.content.animation.animation.id
				anim_name = data.content.animation.file_name
				tdbot.downloadFile(anim_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageVoice" then
		voice_id = ''
		local function get_cb(arg, data)
			if data.content then
				voice_id = data.content.voice.voice.id
				tdbot.downloadFile(voice_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageAudio" then
		audio_id, audio_name, audio_title = '', '', ''
		local function get_cb(arg, data)
			if data.content then
				audio_id = data.content.audio.audio.id
				audio_name = data.content.audio.file_name
				audio_title = data.content.audio.title
				tdbot.downloadFile(audio_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageSticker" then
		sticker_id = ''
		local function get_cb(arg, data)
			if data.content then
				sticker_id = data.content.sticker.sticker.id
				tdbot.downloadFile(sticker_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageDocument" then
		document_id, document_name = '', ''
		local function get_cb(arg, data)
			if data.content then
				document_id = data.content.document.document.id
				document_name = data.content.document.file_name
				tdbot.downloadFile(document_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	end
end
--######################################################################--
function tdbot_update_callback (data)
	if data.message then
		if msg_caption ~= get_text_msg() then
			msg_caption = get_text_msg()
		end
	end
	if (data._ == "updateNewMessage") then
		local msg = data.message
		local d = data.disable_notification
		local chat = chats[msg.chat_id]
		local hash = 'msgs:'..(msg.sender_user_id or 0)..':'..msg.chat_id
		local gaps = 'msgs:'..(msg.chat_id or 0)
		redis:incr(RedisIndex..hash)
		redis:incr(RedisIndex..gaps)
		if redis:get(RedisIndex..'markread') == 'on' then
			tdbot.openChat(msg.chat_id)
			tdbot.viewMessages(msg.chat_id, {[0] = msg.id}, dl_cb, nil)
		end
		if ((not d) and chat) then
			if msg.content._ == "messageText" then
				do_notify (chat.title, msg.content.text)
			else
				do_notify (chat.title, msg.content._)
			end
		end
		if msg_valid(msg) then
			local AutoDownload = redis:get(RedisIndex..'AutoDownload:'..msg.chat_id)
			var_cb(msg, msg)
			if AutoDownload then
				file_cb(msg)
			end
			if msg.forward_info then
				if msg.forward_info._ == "messageForwardedFromUser" then
					msg.fwd_from_user = true
					
				elseif msg.forward_info._ == "messageForwardedPost" then
					msg.fwd_from_channel = true
				end
			end
			if msg.content._ == "messageText" then
				msg.text = msg.content.text
				msg.edited = false
				msg.pinned = false
			elseif msg.content._ == "messagePinMessage" then
				msg.pinned = true
			elseif msg.content._ == "messagePhoto" then
				msg.photo = true
			elseif msg.content._ == "messageVideo" then
				msg.video = true
				
			elseif msg.content._ == "messageVideoNote" then
				msg.video_note = true
				
			elseif msg.content._ == "messageAnimation" then
				msg.animation = true
				
			elseif msg.content._ == "messageVoice" then
				msg.voice = true
				
			elseif msg.content._ == "messageAudio" then
				msg.audio = true
				
			elseif msg.content._ == "messageSticker" then
				msg.sticker = true
				
			elseif msg.content._ == "messageContact" then
				msg.contact = true
				
			elseif msg.content._ == "messageDocument" then
				msg.document = true
				
			elseif msg.content._ == "messageLocation" then
				msg.location = true
			elseif msg.content._ == "messageGame" then
				msg.game = true
			elseif msg.content._ == "messageChatAddMembers" then
				for i=0,#msg.content.member_user_ids do
					msg.adduser = msg.content.member_user_ids[i]
				end
			elseif msg.content._ == "messageChatJoinByLink" then
				msg.joinuser = msg.sender_user_id
			elseif msg.content._ == "messageChatDeleteMember" then
				msg.deluser = true
				
			end
		end
	elseif data._ == "updateMessageEdited" then
		local function edited_cb(arg, data)
			msg = data
			msg.media = {}
			msg.text = msg.content.text
			msg.media.caption = msg.content.caption
			msg.edited = true
			if msg_valid(msg) then
				var_cb(msg, msg)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = data.chat_id, message_id = data.message_id }, edited_cb, nil))
	elseif (data._ == "updateChat") then
		chat = data.chat
		chats[chat.id] = chat
	elseif (data._ == "updateOption" and data.name == "my_id") then
		assert (tdbot_function ({_ = "openChat", chat_id = data.chat_id}, dl_cb, nil))
		assert (tdbot_function ({_ = 'openMessageContent', chat_id = data.chat_id, message_id = data.message_id}, dl_cb, nil))
		assert (tdbot_function ({_ = "getChats", offset_order="9223372036854775807", offset_chat_id=0, limit=20}, dl_cb, nil))
	end
end

