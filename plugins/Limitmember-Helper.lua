local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if msg.query and msg.query:sub(1,6) == "Addl:-" and msg.query:gsub("Addl:-",""):match('%d+') and is_sudo(msg) then
	local chatid = "-"..msg.query:match("%d+")
	local getadd = redis:hget(RedisIndex..'addmemset', chatid) or "0"
	local add = redis:hget(RedisIndex..'addmeminv' ,chatid)
	local sadd = (add == 'on') and "✅" or "✖️" 
	if redis:get(RedisIndex..'addpm'..chatid) then
	addpm = "✖️"
	else
	addpm = "✅"
	end
	keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = '❃ محدودیت اضافه کردن : '..getadd..'', callback_data = 'MaTaDoRTeaM:'..chatid}
		},
		{
			{text = '➕', callback_data = '/addlimup:'..chatid},
			{text = '➖', callback_data = '/addlimdown:'..chatid}
		},
		{
			{text = '❃ وضعیت محدودیت : '..sadd..'', callback_data = 'MaTaDoRTeaM:'..chatid}
		},
		{
			{text = '▪️ فعال', callback_data = '/addlimlock:'..chatid},
			{text = '▪️ غیرفعال', callback_data = '/addlimunlock:'..chatid}
		},
		{
			{text = '❃ ارسال پیام محدودیت : '..addpm..'', callback_data = 'MaTaDoRTeaM:'..chatid}
		},
		{
			{text = '▪️ فعال', callback_data = '/addpmon:'..chatid},
			{text = '▪️ غیرفعال', callback_data = '/addpmoff:'..chatid}
		},
		{
			{text= '❃ بستن پنل شیشه‌ای 🔚' ,callback_data = '/exitadd:'..chatid}
		}
	}
	send_inline(msg.id,'settings','Group Option','Tap Here','●•۰ به بخش تنظیمات اد اجباری خوشآمدید','Markdown',keyboard)
end
--######################################################################--
if mr_roo[1] == '/addlimup' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
			getadd = redis:hget(RedisIndex..'addmemset', mr_roo[2]) or "0"
			if tonumber(getadd) < 10 then
			redis:hset(RedisIndex..'addmemset', mr_roo[2], getadd + 1)
			text = "تنظیم محدودیت اضافه کردن کاربر به : "..getadd
			get_alert(msg.cb_id, text)
			end
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/addlimdown' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
			getadd = redis:hget(RedisIndex..'addmemset', mr_roo[2]) or "0"
			if tonumber(getadd) > 1 then
			redis:hset(RedisIndex..'addmemset', mr_roo[2], getadd - 1)	
			text = "تنظیم محدودیت اضافه کردن کاربر به : "..getadd
			get_alert(msg.cb_id, text)
			end
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/addlimlock' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
		redis:hset(RedisIndex..'addmeminv', mr_roo[2], 'on')
		Canswer(msg.cb_id, "₪ محدودیت اضافه کردن کاربر #فعال شد" ,true)
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/addlimunlock' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
		redis:hset(RedisIndex..'addmeminv', mr_roo[2], 'off')
		Canswer(msg.cb_id, "₪ محدودیت اضافه کردن کاربر #غیرفعال شد" ,true)
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/addpmon' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
		redis:del(RedisIndex..'addpm'..mr_roo[2])
		Canswer(msg.cb_id, "₪ ارسال پیام محدودیت کاربر #فعال شد" ,true)
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/addpmoff' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
    Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true)
	else
		redis:set(RedisIndex..'addpm'..mr_roo[2], true)
		Canswer(msg.cb_id, "₪ ارسال پیام محدودیت کاربر #غیرفعال شد" ,true)
		addlimpanel(msg, mr_roo[2])
	end
end	
--######################################################################--
if mr_roo[1] == '/exitadd' then
	if not is_mod1(mr_roo[2], msg.from.id) then
     get_alert(msg.cb_id, "شما مدیر نیستید \nبرای خرید ربات به پیوی :\n "..sudo_username.."\nیا به کانال زیر مراجعه کنید :\n "..channel_username.."")
   elseif not is_req(mr_roo[2], msg.from.id) then 
        Canswer(msg.cb_id, "شما این فهرست را درخواست نکردید" ,true) 
	else
		 text = 'ツ تنظیمات محدودیت کاربر بسته شده'
		edit_inline(msg.message_id, text)
	end
end
end
	  
return {
patterns ={"^(Addl:[-]%d+)$","^###cb:(Addl:%d+)$","^###cb:(/addlimup):(.*)$","^###cb:(/addlimdown):(.*)$","^###cb:(/addlimlock):(.*)$","^###cb:(/addlimunlock):(.*)$","^###cb:(/addpmon):(.*)$","^###cb:(/addpmoff):(.*)$","^###cb:(/exitadd):(.*)$"},
run = MaTaDoRTeaM
}