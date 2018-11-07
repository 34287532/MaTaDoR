local clock = os.clock
function sleep(time) 
  local t0 = clock()
  while clock() - t0 <= time do end
end
--######################################################################--
function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end
--######################################################################--
function plugins_names( )
  local files = {}
  for k, v in pairs(scandir("plugins")) do
    if (v:match(".lua$")) then
      table.insert(files, v)
    end
  end
  return files
end
--######################################################################--
function check_markdown(text)
		str = text
        if str ~= nil then
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
   end
end
--######################################################################--
function is_sudo(msg)
  local var = false
  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
      var = true
    end
  end
  return var
end
--######################################################################--
function is_owner(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end
--######################################################################--
MahDiRoO = 464555636
--######################################################################--
function is_admin(msg)
  local var = false
  local user = msg.from.id
  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end
--######################################################################--
function is_mod(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['mods'] then
      if data[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end
--######################################################################--
function is_sudo1(user_id)
  local var = false
  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
      var = true
    end
  end
  return var
end
--######################################################################--
function is_owner1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(user)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end
--######################################################################--
function is_admin1(user_id)
  local var = false
  local user = user_id
  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end
--######################################################################--
function is_mod1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['mods'] then
      if data[tostring(chat_id)]['mods'][tostring(usert)] then
        var = true
      end
    end
  end

  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(usert)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end
--######################################################################--
function is_req(chat_id, user_id)
  local var = false
  if redis:get(RedisIndex.."ReqMenu:" .. chat_id .. ":" .. user_id) then
  redis:setex(RedisIndex.."ReqMenu:" .. chat_id .. ":" .. user_id, 260, true)
  redis:setex(RedisIndex.."ReqMenu:" .. chat_id, 10, true)
  var = true
  end
  return var
end
--######################################################################--
function is_filter(msg, text)
local var = false
local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat.id)]['filterlist'] then
for k,v in pairs(data[tostring(msg.chat.id)]['filterlist']) do 
    if string.find(string.lower(text), string.lower(k)) then
       var = true
        end
     end
  end
 return var
end
--######################################################################--
function is_banned(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['banned'] then
      if data[tostring(chat_id)]['banned'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end
--######################################################################--
 function is_silent_user(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['is_silent_users'] then
      if data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end
--######################################################################--
function locks(msg, GP_id, name, temp, cb, back, v, st)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
local data = load_data(_config.moderation.data)
	if data[tostring(GP_id)] and data[tostring(GP_id)]['settings'] then
		settings = data[tostring(GP_id)]['settings']
	else
		return
	end
	if settings.temp then
		temp = settings.temp
		else
		temp = 'no'
	end
	text = '● تنظیمات پیشرفته قفل '..v..''
	keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = ''..name..' : '..st, callback_data = "/"..cb.."enable:"..GP_id},

		},
		{
			{text = '⇜ فعال', callback_data = "/"..cb.."enable:"..GP_id},
			{text = '⇜ غیر فعال', callback_data = "/"..cb.."disable:"..GP_id}
		},
		{
			{text = '⇜ اخطار', callback_data = "/"..cb.."warn:"..GP_id}
		},
		{
			{text = '⇜ سکوت', callback_data = "/"..cb.."mute:"..GP_id},
			{text = '⇜ اخراج', callback_data = "/"..cb.."kick:"..GP_id}
		},
		{
			{text = '⇜ بازگشت', callback_data = back..GP_id}
		}
	}
	edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function options(msg, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	text = '●•۰ به پنل مدیریت گروه خوش آمدید'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
            {text = "❤️ "..tostring(redis:get(RedisIndex.."MaTaDoRLikes")), callback_data="/like:"..GP_id},
            {text = "💔 "..tostring(redis:get(RedisIndex.."MaTaDoRDisLikes")), callback_data="/dislike:"..GP_id}
        },
		{
			{text = "❃ تنظیمات ⚙️", callback_data="/settings:"..GP_id}
		},
		{
			{text = '❃ اطلاعات گروه و مدیریت لیست‌ها 🔬', callback_data = '/more:'..GP_id}
		},
		{
			{text = '❃ تلویزیون 📺', callback_data = '/tv:'..GP_id}
		},
		{
			{text= '❃ بستن پنل شیشه‌ای 🔚' ,callback_data = '/exit:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function moresetting(msg, data, GP_id)
local settings = data[tostring(GP_id)]["settings"]
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
    text = '●• به تنظیمات بیشتر گروه خوش آمدید'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
			{text = '➢ حداکثر پیام های مکرر ', callback_data = 'MaTaDoRTeaM:'}
		},
		{
			{text = "➕", callback_data='/floodup:'..GP_id}, 
			{text = tostring(settings.num_msg_max), callback_data = 'MaTaDoRTeaM:' },
			{text = "➖", callback_data='/flooddown:'..GP_id}
		},
		{
			{text = '➢ حداکثر حروف مجاز ', callback_data = 'MaTaDoRTeaM:'}
		},
		{
			{text = "➕", callback_data='/charup:'..GP_id}, 
			{text = tostring(settings.set_char), callback_data = 'MaTaDoRTeaM:'},
			{text = "➖", callback_data='/chardown:'..GP_id}
		},
		{
			{text = '➢ زمان بررسی پیام های مکرر ', callback_data = 'MaTaDoRTeaM:'}
		},
		{
			{text = "➕", callback_data='/floodtimeup:'..GP_id}, 
			{text = tostring(settings.time_check), callback_data = 'MaTaDoRTeaM:'},
			{text = "➖", callback_data='/floodtimedown:'..GP_id}
		},
		{
			{text = '⇜ بازگشت ', callback_data = '/settings:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function setting(msg, data, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	lock_link = redis:get(RedisIndex..'lock_link:'..GP_id)
	lock_join = redis:get(RedisIndex..'lock_join:'..GP_id)
	lock_tag = redis:get(RedisIndex..'lock_tag:'..GP_id)
	lock_username = redis:get(RedisIndex..'lock_username:'..GP_id)
	lock_pin = redis:get(RedisIndex..'lock_pin:'..GP_id)
	lock_arabic = redis:get(RedisIndex..'lock_arabic:'..GP_id)
	lock_mention = redis:get(RedisIndex..'lock_mention:'..GP_id)
	lock_edit = redis:get(RedisIndex..'lock_edit:'..GP_id)
	lock_spam = redis:get(RedisIndex..'lock_spam:'..GP_id)
	lock_flood = redis:get(RedisIndex..'lock_flood:'..GP_id)
	lock_markdown = redis:get(RedisIndex..'lock_markdown:'..GP_id)
	lock_webpage = redis:get(RedisIndex..'lock_webpage:'..GP_id)
	lock_welcome = redis:get(RedisIndex..'welcome:'..GP_id)
	lock_views = redis:get(RedisIndex..'lock_views:'..GP_id)
	lock_bots = redis:get(RedisIndex..'lock_bots:'..GP_id)
	local Link = (lock_link == "Warn") and "• حالت اخطار" or ((lock_link == "Kick") and "• حالت اخراج" or ((lock_link == "Mute") and "• حالت سکوت" or ((lock_link == "Enable") and "• فعال" or "• غیرفعال")))
	local Tags = (lock_tag == "Warn") and "• حالت اخطار" or ((lock_tag == "Kick") and "• حالت اخراج" or ((lock_tag == "Mute") and "• حالت سکوت" or ((lock_tag == "Enable") and "• فعال" or "• غیرفعال")))
	local User = (lock_username == "Warn") and "• حالت اخطار" or ((lock_username == "Kick") and "• حالت اخراج" or ((lock_username == "Mute") and "• حالت سکوت" or ((lock_username == "Enable") and "• فعال" or "• غیرفعال")))
	local Fa = (lock_arabic == "Warn") and "• حالت اخطار" or ((lock_arabic == "Kick") and "• حالت اخراج" or ((lock_arabic == "Mute") and "• حالت سکوت" or ((lock_arabic == "Enable") and "• فعال" or "• غیرفعال")))
	local Mention = (lock_mention == "Warn") and "• حالت اخطار" or ((lock_mention == "Kick") and "• حالت اخراج" or ((lock_mention == "Mute") and "• حالت سکوت" or ((lock_mention == "Enable") and "• فعال" or "• غیرفعال")))
	local Edit = (lock_edit == "Warn") and "• حالت اخطار" or ((lock_edit == "Kick") and "• حالت اخراج" or ((lock_edit == "Mute") and "• حالت سکوت" or ((lock_edit == "Enable") and "• فعال" or "• غیرفعال")))
	local Mar = (lock_markdown == "Warn") and "• حالت اخطار" or ((lock_markdown == "Kick") and "• حالت اخراج" or ((lock_markdown == "Mute") and "• حالت سکوت" or ((lock_markdown == "Enable") and "• فعال" or "• غیرفعال")))
	local Web = (lock_webpage == "Warn") and "• حالت اخطار" or ((lock_webpage == "Kick") and "• حالت اخراج" or ((lock_webpage == "Mute") and "• حالت سکوت" or ((lock_webpage == "Enable") and "• فعال" or "• غیرفعال")))
	local Views = (lock_views == "Warn") and "• حالت اخطار" or ((lock_views == "Kick") and "• حالت اخراج" or ((lock_views == "Mute") and "• حالت سکوت" or ((lock_views == "Enable") and "• فعال" or "• غیرفعال")))
	local Bot =  (lock_bots == "Enable" and "• فعال" or "• غیرفعال")
	local Join =  (lock_join == "Enable" and "• فعال" or "• غیرفعال")
	local Pin =  (lock_pin == "Enable" and "• فعال" or "• غیرفعال")
	local Spam =  (lock_spam == "Enable" and "• فعال" or "• غیرفعال")
	local Flood =  (lock_flood == "Enable" and "• فعال" or "• غیرفعال")
	local Wel = (lock_welcome == "Enable" and "• فعال" or "• غیرفعال")
    text = '●• به تنظیمات گروه خوش آمدید'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
			{text = "⇜ قفل ویرایش : "..Edit, callback_data="/lockedit:"..GP_id}
		},
		{
			{text = "⇜ قفل لینک : "..Link, callback_data="/locklink:"..GP_id}
		},
		{
			{text = "⇜ قفل تگ : "..Tags, callback_data="/locktags:"..GP_id}
		},
		{
			{text = "⇜ قفل نام کاربری : "..User, callback_data="/lockusernames:"..GP_id}
		},
		{
			{text = "⇜ قفل بازدید : "..Views, callback_data="/lockviews:"..GP_id}
		},
		{
			{text = "⇜ قفل ورود : "..Join, callback_data="/lockjoin:"..GP_id}
		},
		{
			{text = "⇜ قفل پیام های مکرر : "..Flood, callback_data="/lockflood:"..GP_id}
		},
		{
			{text = "⇜ قفل هرزنامه : "..Spam, callback_data="/lockspam:"..GP_id}
		},
		{
			{text = "⇜ قفل فراخوانی : "..Mention, callback_data="/lockmention:"..GP_id}
		},
		{
			{text = "⇜ قفل عربی : "..Fa, callback_data="/lockarabic:"..GP_id}
		},
		{
			{text = "⇜ قفل صفحات وب : "..Web, callback_data="/lockwebpage:"..GP_id}
		},
		{
			{text = "⇜ قفل فونت : "..Mar, callback_data="/lockmarkdown:"..GP_id}
		},
		{
			{text = "⇜ قفل سنجاق کردن : "..Pin, callback_data="/lockpin:"..GP_id}
		},
		{
			{text = "⇜ قفل ربات ها : "..Bot, callback_data="/lockbots:"..GP_id}
		},
		{
			{text = "⇜ خوشآمد گویی : "..Wel, callback_data="/welcome:"..GP_id}
		},
		{
			{text = '⇜ ادامه تنظیمات ', callback_data = '/mutelist:'..GP_id}
		},
		{
			{text = '⇜ بازگشت ', callback_data = '/option:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function mutelists(msg, data, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	mute_all = redis:get(RedisIndex..'mute_all:'..GP_id)
	mute_gif = redis:get(RedisIndex..'mute_gif:'..GP_id)
	mute_photo = redis:get(RedisIndex..'mute_photo:'..GP_id)
	mute_sticker = redis:get(RedisIndex..'mute_sticker:'..GP_id)
	mute_contact = redis:get(RedisIndex..'mute_contact:'..GP_id)
	mute_inline = redis:get(RedisIndex..'mute_inline:'..GP_id)
	mute_game = redis:get(RedisIndex..'mute_game:'..GP_id)
	mute_text = redis:get(RedisIndex..'mute_text:'..GP_id)
	mute_keyboard = redis:get(RedisIndex..'mute_keyboard:'..GP_id)
	mute_forward = redis:get(RedisIndex..'mute_forward:'..GP_id)
	mute_location = redis:get(RedisIndex..'mute_location:'..GP_id)
	mute_document = redis:get(RedisIndex..'mute_document:'..GP_id)
	mute_voice = redis:get(RedisIndex..'mute_voice:'..GP_id)
	mute_audio = redis:get(RedisIndex..'mute_audio:'..GP_id)
	mute_video = redis:get(RedisIndex..'mute_video:'..GP_id)
	mute_video_note = redis:get(RedisIndex..'mute_video_note:'..GP_id)
	mute_tgservice = redis:get(RedisIndex..'mute_tgservice:'..GP_id)
	local Gif = (mute_gif == "Warn") and "• حالت اخطار" or ((mute_gif == "Kick") and "• حالت اخراج" or ((mute_gif == "Mute") and "• حالت سکوت" or ((mute_gif == "Enable") and "• فعال" or "• غیرفعال")))
	local Photo = (mute_photo == "Warn") and "• حالت اخطار" or ((mute_photo == "Kick") and "• حالت اخراج" or ((mute_photo == "Mute") and "• حالت سکوت" or ((mute_photo == "Enable") and "• فعال" or "• غیرفعال")))
	local Sticker = (mute_sticker == "Warn") and "• حالت اخطار" or ((mute_sticker == "Kick") and "• حالت اخراج" or ((mute_sticker == "Mute") and "• حالت سکوت" or ((mute_sticker == "Enable") and "• فعال" or "• غیرفعال")))
	local Contact = (mute_contact == "Warn") and "• حالت اخطار" or ((mute_contact == "Kick") and "• حالت اخراج" or ((mute_contact == "Mute") and "• حالت سکوت" or ((mute_contact == "Enable") and "• فعال" or "• غیرفعال")))
	local Inline = (mute_inline == "Warn") and "• حالت اخطار" or ((mute_inline == "Kick") and "• حالت اخراج" or ((mute_inline == "Mute") and "• حالت سکوت" or ((mute_inline == "Enable") and "• فعال" or "• غیرفعال")))
	local Game = (mute_game == "Warn") and "• حالت اخطار" or ((mute_game == "Kick") and "• حالت اخراج" or ((mute_game == "Mute") and "• حالت سکوت" or ((mute_game == "Enable") and "• فعال" or "• غیرفعال")))
	local Text = (mute_text == "Warn") and "• حالت اخطار" or ((mute_text == "Kick") and "• حالت اخراج" or ((mute_text == "Mute") and "• حالت سکوت" or ((mute_text == "Enable") and "• فعال" or "• غیرفعال")))
	local Key = (mute_keyboard == "Warn") and "• حالت اخطار" or ((mute_keyboard == "Kick") and "• حالت اخراج" or ((mute_keyboard == "Mute") and "• حالت سکوت" or ((mute_keyboard == "Enable") and "• فعال" or "• غیرفعال")))
	local Fwd = (mute_forward == "Warn") and "• حالت اخطار" or ((mute_forward == "Kick") and "• حالت اخراج" or ((mute_forward == "Mute") and "• حالت سکوت" or ((mute_forward == "Enable") and "• فعال" or "• غیرفعال")))
	local Loc = (mute_location == "Warn") and "• حالت اخطار" or ((mute_location == "Kick") and "• حالت اخراج" or ((mute_location == "Mute") and "• حالت سکوت" or ((mute_location == "Enable") and "• فعال" or "• غیرفعال")))
	local Doc = (mute_document == "Warn") and "• حالت اخطار" or ((mute_document == "Kick") and "• حالت اخراج" or ((mute_document == "Mute") and "• حالت سکوت" or ((mute_document == "Enable") and "• فعال" or "• غیرفعال")))
	local Voice = (mute_voice == "Warn") and "• حالت اخطار" or ((mute_voice == "Kick") and "• حالت اخراج" or ((mute_voice == "Mute") and "• حالت سکوت" or ((mute_voice == "Enable") and "• فعال" or "• غیرفعال")))
	local Audio = (mute_audio == "Warn") and "• حالت اخطار" or ((mute_audio == "Kick") and "• حالت اخراج" or ((mute_audio == "Mute") and "• حالت سکوت" or ((mute_audio == "Enable") and "• فعال" or "• غیرفعال")))
	local Video = (mute_video == "Warn") and "• حالت اخطار" or ((mute_video == "Kick") and "• حالت اخراج" or ((mute_video == "Mute") and "• حالت سکوت" or ((mute_video == "Enable") and "• فعال" or "• غیرفعال")))
	local VSelf = (mute_video_note == "Warn") and "• حالت اخطار" or ((mute_video_note == "Kick") and "• حالت اخراج" or ((mute_video_note == "Mute") and "• حالت سکوت" or ((mute_video_note == "Enable") and "• فعال" or "• غیرفعال")))
	local Tgser =  (mute_tgservice == "Enable" and "• فعال" or "• غیرفعال")
	local All =  (mute_all == "Enable" and "• فعال" or "• غیرفعال")
	text = '●• به لیست بیصدای گروه خوش آمدید'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
			{text = "⇜ بیصدا همه : "..All, callback_data="/muteall:"..GP_id}
		},
		{
			{text = "⇜ بیصدا تصاویر متحرک : "..Gif, callback_data="/mutegif:"..GP_id}
		},
		{ 
			{text = "⇜ بیصدا متن : "..Text, callback_data="/mutetext:"..GP_id}
		},
		{
			{text = "⇜ بیصدا اینلاین : "..Inline, callback_data="/muteinline:"..GP_id}
		},
		{
			{text = "⇜ بیصدا بازی : "..Game, callback_data="/mutegame:"..GP_id}
		},
		{
			{text = "⇜ بیصدا عکس : "..Photo, callback_data="/mutephoto:"..GP_id}
		},
		{
			{text = "⇜ بیصدا فیلم : "..Video, callback_data="/mutevideo:"..GP_id}
		},
		{
			{text = "⇜ بیصدا آهنگ : "..Audio, callback_data="/muteaudio:"..GP_id}
		},
		{
			{text = "⇜ بیصدا صدا : "..Voice, callback_data="/mutevoice:"..GP_id}
		},
		{
			{text = "⇜ بیصدا استیکر : "..Sticker, callback_data="/mutesticker:"..GP_id}
		},
		{
			{text = "⇜ بیصدا مخاطب : "..Contact, callback_data="/mutecontact:"..GP_id}
		},
		{
			{text = "⇜ بیصدا نقل و قول :" ..Fwd, callback_data="/muteforward:"..GP_id}
		},
		{ 
			{text = "⇜ بیصدا موقعیت : "..Loc, callback_data="/mutelocation:"..GP_id}
		},
		{
			{text = "⇜ بیصدا فایل : "..Doc, callback_data="/mutedocument:"..GP_id}
		},
		{
			{text = "⇜ بیصدا خدمات تلگرام : "..Tgser, callback_data="/mutetgservice:"..GP_id}
		},
		{
			{text = "⇜ بیصدا کیبورد : "..Key, callback_data="/mutekeyboard:"..GP_id}
		},
		{
			{text = "⇜ بیصدا فیلم سلفی : "..VSelf, callback_data="/mutevideonote:"..GP_id}
        },
		{
			{text = '⇜ تنظیمات بیشتر ', callback_data = '/moresettings:'..GP_id}
		},
        {
			{text = '⇜ بازگشت ', callback_data = '/settings:'..GP_id}
		}		
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function lockhelp(msg, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	text = '●•۰ به راهنمای قفلی خوشآمدید'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
			{text = "⇜ قفل خودکار گروه", callback_data="/lockh31:"..GP_id},
		},
		{
			{text = "⇜ همه", callback_data="/lockh1:"..GP_id},
			{text = "⇜ لینک", callback_data="/lockh2:"..GP_id},
			{text = "⇜ فوروارد", callback_data="/lockh3:"..GP_id}
		},
		{
			{text = "⇜ تگ", callback_data="/lockh4:"..GP_id},
			{text = "⇜ منشن", callback_data="/lockh5:"..GP_id},
			{text = "⇜ فارسی", callback_data="/lockh6:"..GP_id}
		},
		{
			{text = "⇜ ویرایش", callback_data="/lockh7:"..GP_id},
			{text = "⇜ هرزنامه", callback_data="/lockh8:"..GP_id},
			{text = "⇜ پیام مکرر", callback_data="/lockh9:"..GP_id}
		},
		{
			{text = "⇜ ربات", callback_data="/lockh10:"..GP_id},
			{text = "⇜ فونت", callback_data="/lockh11:"..GP_id},
			{text = "⇜ وبسایت", callback_data="/lockh12:"..GP_id}
		},
		{
			{text = "⇜ سنجاق", callback_data="/lockh13:"..GP_id},
			{text = "⇜ ورود", callback_data="/lockh14:"..GP_id},
			{text = "⇜ گیف", callback_data="/lockh15:"..GP_id}
		},
		{
			{text = "⇜ متن", callback_data="/lockh16:"..GP_id},
			{text = "⇜ عکس", callback_data="/lockh17:"..GP_id},
			{text = "⇜ فیلم", callback_data="/lockh18:"..GP_id}
		},
		{
			{text = "⇜ فیلم سلفی", callback_data="/lockh19:"..GP_id},
			{text = "⇜ آهنگ", callback_data="/lockh20:"..GP_id},
			{text = "⇜ ویس", callback_data="/lockh21:"..GP_id}
		},
		{
			{text = "⇜ استیکر", callback_data="/lockh22:"..GP_id},
			{text = "⇜ مخاطب", callback_data="/lockh23:"..GP_id},
			{text = "⇜ مکان", callback_data="/lockh24:"..GP_id}
		},
		{
			{text = "⇜ فایل", callback_data="/lockh25:"..GP_id},
			{text = "⇜ سرویس تلگرام", callback_data="/lockh26:"..GP_id},
			{text = "⇜ دکمه شیشه ای", callback_data="/lockh27:"..GP_id}
		},
		{
			{text = "⇜ بازی", callback_data="/lockh28:"..GP_id},
			{text = "⇜ کیبورد شیشه ای", callback_data="/lockh29:"..GP_id},
			{text = "⇜ بازدید", callback_data="/lockh30:"..GP_id}
		},
		{
			{text= '⇜ بازگشت' ,callback_data = '/helplist:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function helplist(msg, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	local url = http.request('http://probot.000webhostapp.com/api/time.php/')
	local jdat = json:decode(url)
	text = '*●•۰ به بخش راهنمای ربات خوشآمدید*\n*'..M_START..'توجه داشته باشید این پنل راهنما مخصوص به مدیران و مالک گروه میباشد'..EndPm..'*\n`❃ برای حمایت از ما لطفا در نظر سنجی ربات شرکت کنید`\n\n*ساعت : * `'..jdat.Stime..'`\n*تاریخ :* `'..jdat.FAdate..'`'
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
            {text = "❤️ "..tostring(redis:get(RedisIndex.."MaTaDoRLikes")), callback_data="/likehelp:"..GP_id},
            {text = "💔 "..tostring(redis:get(RedisIndex.."MaTaDoRDisLikes")), callback_data="/dislikehelp:"..GP_id}
        },
		{
			{text = M_START..'راهنمای مدیریتی', callback_data = '/helpmod:'..GP_id}
		},
		{
			{text = M_START..'پاکسازی لیستی', callback_data = '/helpclean:'..GP_id},
			{text = M_START..'پاکسازی پیام', callback_data = '/helpclean1:'..GP_id}
		},
		{
			{text = M_START..'راهنمای پنل ها', callback_data = '/helppn:'..GP_id}
		},
		{
			{text = M_START..'لیستی ربات', callback_data = '/helplisti:'..GP_id},
			{text = M_START..'تنظیمی ربات', callback_data = '/helpseti:'..GP_id}
		},
		{
			{text = M_START..'راهنمای قفلی', callback_data = '/helplock:'..GP_id}
		},
		{
			{text = M_START..'محدودیت و ارتقا', callback_data = '/helpmah:'..GP_id},
			{text = M_START..'سرگرمی', callback_data = '/helpfun:'..GP_id}
		},
		{
			{text= M_START..'بستن پنل شیشه‌ای' ,callback_data = '/exithelp:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function sudopanel(msg, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	text = '●•۰ به پنل مدیریتی سودو ربات خوش آمدید'
	local m_read = redis:get(RedisIndex..'markread')
	if redis:get(RedisIndex..'auto_leave_bot') then
	Autoleave = "✖️"
	else
	Autoleave = "✅"
	end
	if m_read == 'on' then
	Markread = "✅"
	else
	Markread = "✖️"
	end
	keyboard = {} 
	keyboard.inline_keyboard = {
		{
			{text = '❃ اطلاعات مربوط به سودو', callback_data = '/infosudo1:'..GP_id}
		},
		{
			{text = '❃ راهنمای سودو', callback_data = '/helpsudo1:'..GP_id},
			{text = '❃ لیست سودو ها', callback_data = '/sudolist1:'..GP_id}
		},
		{
			{text = '❃ تیک دوم : '..Markread..'', callback_data = '/markread:'..GP_id}
		},
		{
			{text = '❃ خروج خودکار : '..Autoleave..'', callback_data = '/autoleave:'..GP_id}
		},
		{
			{text= '❃ بستن پنل شیشه‌ای 🔚' ,callback_data = '/exitsudo:'..GP_id}
		}				
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function addlimpanel(msg, GP_id)
	local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
	local M_START = StartPm[math.random(#StartPm)]
	text = '`₪ به بخش تنظیمات اد اجباری خوشآمدید`'
	local getadd = redis:hget(RedisIndex..'addmemset', GP_id) or "0"
	local add = redis:hget(RedisIndex..'addmeminv' ,GP_id)
	local sadd = (add == 'on') and "✅" or "✖️" 
	if redis:get(RedisIndex..'addpm'..GP_id) then
	addpm = "✖️"
	else
	addpm = "✅"
	end
	keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = '❃ محدودیت اضافه کردن : '..getadd..'', callback_data = 'MaTaDoRTeaM:'..GP_id}
		},
		{
			{text = '➕', callback_data = '/addlimup:'..GP_id},
			{text = '➖', callback_data = '/addlimdown:'..GP_id}
		},
		{
			{text = '❃ وضعیت محدودیت : '..sadd..'', callback_data = 'MaTaDoRTeaM:'..GP_id}
		},
		{
			{text = '▪️ فعال', callback_data = '/addlimlock:'..GP_id},
			{text = '▪️ غیرفعال', callback_data = '/addlimunlock:'..GP_id}
		},
		{
			{text = '❃ ارسال پیام محدودیت : '..addpm..'', callback_data = 'MaTaDoRTeaM:'..GP_id}
		},
		{
			{text = '▪️ فعال', callback_data = '/addpmon:'..GP_id},
			{text = '▪️ غیرفعال', callback_data = '/addpmoff:'..GP_id}
		},
		{
			{text= '❃ بستن پنل شیشه‌ای 🔚' ,callback_data = '/exitadd:'..GP_id}
		}
	}
    edit_inline(msg.message_id, text, keyboard)
end
--######################################################################--
function get_var_inline(msg)
if msg.query then
if msg.query:match("-%d+") then
msg.chat = {}
msg.chat.id = "-"..msg.query:match("%d+")
    end
elseif not msg.query then
msg.chat.id = msg.chat.id
end
match_plugins(msg)
end
function get_var(msg)
msg.reply = {}
msg.fwd_from = {}
 msg.data = {}
msg.id = msg.message_id
if msg.reply_to_message then
msg.reply_id = msg.reply_to_message.message_id
msg.reply.id = msg.reply_to_message.from.id
if msg.reply_to_message.from.last_name then
msg.reply.print_name = msg.reply_to_message.from.first_name..' '..msg.reply_to_message.from.last_name
else
msg.reply.print_name = msg.reply_to_message.from.first_name
end
msg.reply.first_name = msg.reply_to_message.from.first_name
msg.reply.last_name = msg.reply_to_message.from.last_name
msg.reply.username = msg.reply_to_message.from.username
end
if msg.from.last_name then
msg.from.print_name = msg.from.first_name..' '..msg.from.last_name
else
msg.from.print_name = msg.from.first_name
end
if msg.forward_from then
msg.fwd_from.id = msg.forward_from.id
msg.fwd_from.first_name = msg.forward_from.first_name
msg.fwd_from.last_name = msg.forward_from.last_name
if msg.forward_from.last_name then
msg.fwd_from.print_name = msg.forward_from.first_name..' '..msg.forward_from.last_name
else
msg.fwd_from.print_name = msg.forward_from.first_name
end
msg.fwd_from.username = msg.forward_from.username
end
match_plugins(msg)
end
