local function MaTaDoRTeaM(msg, mr_roo)
local StartPm = {"↫ ","⇜ ","⌯ ","℘ ","↜ ","⇋ "}
local M_START = StartPm[math.random(#StartPm)]
if ((mr_roo[1]:lower() == "lock" ) or (mr_roo[1] == "قفل" )) and is_mod(msg) then
	if ((mr_roo[2] == "link" ) or (mr_roo[2] == "لینک" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, 'lock_link', "لینک")
	elseif ((mr_roo[2] == "tag" ) or (mr_roo[2] == "تگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_tag", "تگ")
	elseif ((mr_roo[2] == "views" ) or (mr_roo[2] == "ویو" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_views", "ویو")
	elseif ((mr_roo[2] == "username" ) or (mr_roo[2] == "نام کاربری" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_username", "نام کاربری")
	elseif ((mr_roo[2] == "mention" ) or (mr_roo[2] == "منشن" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_mention", "منشن")
	elseif ((mr_roo[2] == "arabic" ) or (mr_roo[2] == "فارسی" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_arabic", "فارسی")
	elseif ((mr_roo[2] == "edit" ) or (mr_roo[2] == "ویرایش" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_edit", "ویرایش")
	elseif ((mr_roo[2] == "spam" ) or (mr_roo[2] == "هرزنامه" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_spam", "هرزنامه")
	elseif ((mr_roo[2] == "flood" ) or (mr_roo[2] == "پیام مکرر" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_flood", "پیام مکرر")
	elseif ((mr_roo[2] == "bots" ) or (mr_roo[2] == "ربات" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_bots", "ربات")
	elseif ((mr_roo[2] == "markdown" ) or (mr_roo[2] == "فونت" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_markdown", "فونت")
	elseif ((mr_roo[2] == "webpage" ) or (mr_roo[2] == "وب" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_webpage", "وب")
	elseif ((mr_roo[2] == "pin" ) or (mr_roo[2] == "سنجاق" )) and is_JoinChannel(msg) and is_owner(msg) then
		Lock_Delmsg(msg, "lock_pin", "سنجاق")
	elseif ((mr_roo[2] == "join" ) or (mr_roo[2] == "ورود" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "lock_join", "ورود")
	elseif ((mr_roo[2] == "all" ) or (mr_roo[2] == "همه" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_all", "همه")
	elseif ((mr_roo[2] == "gif" ) or (mr_roo[2] == "گیف" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_gif", "گیف")
	elseif ((mr_roo[2] == "text" ) or (mr_roo[2] == "متن" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_text", "متن")
	elseif ((mr_roo[2] == "photo" ) or (mr_roo[2] == "عکس" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_photo", "عکس")
	elseif ((mr_roo[2] == "video" ) or (mr_roo[2] == "فیلم" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_video", "فیلم")
	elseif ((mr_roo[2] == "video_note" ) or (mr_roo[2] == "فیلم سلفی" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_video_note", "فیلم سلفی")
	elseif ((mr_roo[2] == "audio" ) or (mr_roo[2] == "اهنگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_audio", "آهنگ")
	elseif ((mr_roo[2] == "voice" ) or (mr_roo[2] == "صدا" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_voice", "صدا")
	elseif ((mr_roo[2] == "sticker" ) or (mr_roo[2] == "استیکر" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_sticker", "استیکر")
	elseif ((mr_roo[2] == "contact" ) or (mr_roo[2] == "مخاطب" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_contact", "مخاطب")
	elseif ((mr_roo[2] == "forward" ) or (mr_roo[2] == "فوروارد" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_forward", "فوروارد")
	elseif ((mr_roo[2] == "location" ) or (mr_roo[2] == "موقعیت" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_location", "موقعیت")
	elseif ((mr_roo[2] == "document" ) or (mr_roo[2] == "فایل" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_document", "فایل")
	elseif ((mr_roo[2] == "tgservice" ) or (mr_roo[2] == "سرویس تلگرام" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_tgservice", "سرویس تلگرام")
	elseif ((mr_roo[2] == "inline" ) or (mr_roo[2] == "کیبورد شیشه ای" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_inline", "کیبورد شیشهای")
	elseif ((mr_roo[2] == "game" ) or (mr_roo[2] == "بازی" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_game", "بازی")
	elseif ((mr_roo[2] == "keyboard" ) or (mr_roo[2] == "صفحه کلید" )) and is_JoinChannel(msg) then
		Lock_Delmsg(msg, "mute_keyboard", "صفحه کلید")
	elseif ((mr_roo[2] == "cmds" ) or (mr_roo[2] == "دستورات" )) and is_JoinChannel(msg) then
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START.."`قفل دستورات` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `فعال شد.`"..EndPm, 1, 'md')
		redis:set(RedisIndex.."lock_cmd"..msg.chat_id,true)
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "warn" ) or (mr_roo[1] == "اخطار" )) and is_mod(msg) then
	if ((mr_roo[2] == "link" ) or (mr_roo[2] == "لینک" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, 'lock_link', "لینک")
	elseif ((mr_roo[2] == "tag" ) or (mr_roo[2] == "تگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_tag", "تگ")
	elseif ((mr_roo[2] == "views" ) or (mr_roo[2] == "ویو" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_views", "ویو")
	elseif ((mr_roo[2] == "username" ) or (mr_roo[2] == "نام کاربری" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_username", "نام کاربری")
	elseif ((mr_roo[2] == "mention" ) or (mr_roo[2] == "منشن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_mention", "منشن")
	elseif ((mr_roo[2] == "arabic" ) or (mr_roo[2] == "فارسی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_arabic", "فارسی")
	elseif ((mr_roo[2] == "edit" ) or (mr_roo[2] == "ویرایش" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_edit", "ویرایش")
	elseif ((mr_roo[2] == "markdown" ) or (mr_roo[2] == "فونت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_markdown", "فونت")
	elseif ((mr_roo[2] == "webpage" ) or (mr_roo[2] == "وب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "lock_webpage", "وب")
	elseif ((mr_roo[2] == "gif" ) or (mr_roo[2] == "گیف" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_gif", "گیف")
	elseif ((mr_roo[2] == "text" ) or (mr_roo[2] == "متن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_text", "متن")
	elseif ((mr_roo[2] == "photo" ) or (mr_roo[2] == "عکس" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_photo", "عکس")
	elseif ((mr_roo[2] == "video" ) or (mr_roo[2] == "فیلم" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_video", "فیلم")
	elseif ((mr_roo[2] == "video_note" ) or (mr_roo[2] == "فیلم سلفی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_video_note", "فیلم سلفی")
	elseif ((mr_roo[2] == "audio" ) or (mr_roo[2] == "اهنگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_audio", "آهنگ")
	elseif ((mr_roo[2] == "voice" ) or (mr_roo[2] == "صدا" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_voice", "صدا")
	elseif ((mr_roo[2] == "sticker" ) or (mr_roo[2] == "استیکر" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_sticker", "استیکر")
	elseif ((mr_roo[2] == "contact" ) or (mr_roo[2] == "مخاطب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_contact", "مخاطب")
	elseif ((mr_roo[2] == "forward" ) or (mr_roo[2] == "فوروارد" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_forward", "فوروارد")
	elseif ((mr_roo[2] == "location" ) or (mr_roo[2] == "موقعیت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_location", "موقعیت")
	elseif ((mr_roo[2] == "document" ) or (mr_roo[2] == "فایل" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_document", "فایل")
	elseif ((mr_roo[2] == "inline" ) or (mr_roo[2] == "کیبورد شیشه ای" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_inline", "کیبورد شیشه ای")
	elseif ((mr_roo[2] == "game" ) or (mr_roo[2] == "بازی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_game", "بازی")
	elseif ((mr_roo[2] == "keyboard" ) or (mr_roo[2] == "صفحه کلید" )) and is_JoinChannel(msg) then
		Lock_Delmsg_warn(msg, "mute_keyboard", "صفحه کلید")
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "kick" ) or (mr_roo[1] == "اخراج" )) and is_mod(msg) then
	if ((mr_roo[2] == "link" ) or (mr_roo[2] == "لینک" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, 'lock_link', "لینک")
	elseif ((mr_roo[2] == "tag" ) or (mr_roo[2] == "تگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_tag", "تگ")
	elseif ((mr_roo[2] == "views" ) or (mr_roo[2] == "ویو" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_views", "ویو")
	elseif ((mr_roo[2] == "username" ) or (mr_roo[2] == "نام کاربری" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_username", "نام کاربری")
	elseif ((mr_roo[2] == "mention" ) or (mr_roo[2] == "منشن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_mention", "منشن")
	elseif ((mr_roo[2] == "arabic" ) or (mr_roo[2] == "فارسی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_arabic", "فارسی")
	elseif ((mr_roo[2] == "edit" ) or (mr_roo[2] == "ویرایش" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_edit", "ویرایش")
	elseif ((mr_roo[2] == "markdown" ) or (mr_roo[2] == "فونت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_markdown", "فونت")
	elseif ((mr_roo[2] == "webpage" ) or (mr_roo[2] == "وب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "lock_webpage", "وب")
	elseif ((mr_roo[2] == "gif" ) or (mr_roo[2] == "گیف" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_gif", "گیف")
	elseif ((mr_roo[2] == "text" ) or (mr_roo[2] == "متن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_text", "متن")
	elseif ((mr_roo[2] == "photo" ) or (mr_roo[2] == "عکس" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_photo", "عکس")
	elseif ((mr_roo[2] == "video" ) or (mr_roo[2] == "فیلم" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_video", "فیلم")
	elseif ((mr_roo[2] == "video_note" ) or (mr_roo[2] == "فیلم سلفی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_video_note", "فیلم سلفی")
	elseif ((mr_roo[2] == "audio" ) or (mr_roo[2] == "اهنگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_audio", "آهنگ")
	elseif ((mr_roo[2] == "voice" ) or (mr_roo[2] == "صدا" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_voice", "صدا")
	elseif ((mr_roo[2] == "sticker" ) or (mr_roo[2] == "استیکر" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_sticker", "استیکر")
	elseif ((mr_roo[2] == "contact" ) or (mr_roo[2] == "مخاطب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_contact", "مخاطب")
	elseif ((mr_roo[2] == "forward" ) or (mr_roo[2] == "فوروارد" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_forward", "فوروارد")
	elseif ((mr_roo[2] == "location" ) or (mr_roo[2] == "موقعیت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_location", "موقعیت")
	elseif ((mr_roo[2] == "document" ) or (mr_roo[2] == "فایل" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_document", "فایل")
	elseif ((mr_roo[2] == "inline" ) or (mr_roo[2] == "کیبورد شیشه ای" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_inline", "کیبورد شیشه ای")
	elseif ((mr_roo[2] == "game" ) or (mr_roo[2] == "بازی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_game", "بازی")
	elseif ((mr_roo[2] == "keyboard" ) or (mr_roo[2] == "صفحه کلید" )) and is_JoinChannel(msg) then
		Lock_Delmsg_kick(msg, "mute_keyboard", "صفحه کلید")
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "mute" ) or (mr_roo[1] == "سکوت" )) and is_mod(msg) then
	if ((mr_roo[2] == "link" ) or (mr_roo[2] == "لینک" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, 'lock_link', "لینک")
	elseif ((mr_roo[2] == "tag" ) or (mr_roo[2] == "تگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_tag", "تگ")
	elseif ((mr_roo[2] == "views" ) or (mr_roo[2] == "ویو" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_views", "ویو")
	elseif ((mr_roo[2] == "username" ) or (mr_roo[2] == "نام کاربری" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_username", "نام کاربری")
	elseif ((mr_roo[2] == "mention" ) or (mr_roo[2] == "منشن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_mention", "منشن")
	elseif ((mr_roo[2] == "arabic" ) or (mr_roo[2] == "فارسی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_arabic", "فارسی")
	elseif ((mr_roo[2] == "edit" ) or (mr_roo[2] == "ویرایش" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_edit", "ویرایش")
	elseif ((mr_roo[2] == "markdown" ) or (mr_roo[2] == "فونت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_markdown", "فونت")
	elseif ((mr_roo[2] == "webpage" ) or (mr_roo[2] == "وب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "lock_webpage", "وب")
	elseif ((mr_roo[2] == "gif" ) or (mr_roo[2] == "گیف" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_gif", "گیف")
	elseif ((mr_roo[2] == "text" ) or (mr_roo[2] == "متن" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_text", "متن")
	elseif ((mr_roo[2] == "photo" ) or (mr_roo[2] == "عکس" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_photo", "عکس")
	elseif ((mr_roo[2] == "video" ) or (mr_roo[2] == "فیلم" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_video", "فیلم")
	elseif ((mr_roo[2] == "video_note" ) or (mr_roo[2] == "فیلم سلفی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_video_note", "فیلم سلفی")
	elseif ((mr_roo[2] == "audio" ) or (mr_roo[2] == "اهنگ" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_audio", "آهنگ")
	elseif ((mr_roo[2] == "voice" ) or (mr_roo[2] == "صدا" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_voice", "صدا")
	elseif ((mr_roo[2] == "sticker" ) or (mr_roo[2] == "استیکر" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_sticker", "استیکر")
	elseif ((mr_roo[2] == "contact" ) or (mr_roo[2] == "مخاطب" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_contact", "مخاطب")
	elseif ((mr_roo[2] == "forward" ) or (mr_roo[2] == "فوروارد" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_forward", "فوروارد")
	elseif ((mr_roo[2] == "location" ) or (mr_roo[2] == "موقعیت" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_location", "موقعیت")
	elseif ((mr_roo[2] == "document" ) or (mr_roo[2] == "فایل" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_document", "فایل")
	elseif ((mr_roo[2] == "inline" ) or (mr_roo[2] == "کیبورد شیشه ای" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_inline", "کیبورد شیشه ای")
	elseif ((mr_roo[2] == "game" ) or (mr_roo[2] == "بازی" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_game", "بازی")
	elseif ((mr_roo[2] == "keyboard" ) or (mr_roo[2] == "صفحه کلید" )) and is_JoinChannel(msg) then
		Lock_Delmsg_mute(msg, "mute_keyboard", "صفحه کلید")
	end
end
--######################################################################--
if ((mr_roo[1]:lower() == "unlock" ) or (mr_roo[1] == "باز کردن" ) or (mr_roo[1] == "بازکردن" )) and is_mod(msg) then
	if ((mr_roo[2] == "link" ) or (mr_roo[2] == "لینک" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_link', "لینک")
	elseif ((mr_roo[2] == "tag" ) or (mr_roo[2] == "تگ" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_tag", "تگ")
	elseif ((mr_roo[2] == "views" ) or (mr_roo[2] == "ویو" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_views", "ویو")
	elseif ((mr_roo[2] == "username" ) or (mr_roo[2] == "نام کاربری" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_username", "نام کاربری")
	elseif ((mr_roo[2] == "mention" ) or (mr_roo[2] == "منشن" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_mention", "منشن")
	elseif ((mr_roo[2] == "arabic" ) or (mr_roo[2] == "فارسی" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_arabic", "فارسی")
	elseif ((mr_roo[2] == "edit" ) or (mr_roo[2] == "ویرایش" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_edit', "ویرایش")
	elseif ((mr_roo[2] == "spam" ) or (mr_roo[2] == "هرزنامه" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_spam', "هرزنامه")
	elseif ((mr_roo[2] == "flood" ) or (mr_roo[2] == "پیام مکرر" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_flood', "پیام مکرر")
	elseif ((mr_roo[2] == "bots" ) or (mr_roo[2] == "ربات" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_bots', "ربات")
	elseif ((mr_roo[2] == "markdown" ) or (mr_roo[2] == "فونت" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_markdown", "فونت")
	elseif ((mr_roo[2] == "webpage" ) or (mr_roo[2] == "وب" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "lock_webpage", "وب")
	elseif ((mr_roo[2] == "pin" ) or (mr_roo[2] == "سنجاق" )) and is_owner(msg) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_pin', "سنجاق")
	elseif ((mr_roo[2] == "join" ) or (mr_roo[2] == "ورود" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, 'lock_join', "ورود")
	elseif ((mr_roo[2] == "all" ) or (mr_roo[2] == "همه" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_all", "همه")
	elseif ((mr_roo[2] == "gif" ) or (mr_roo[2] == "گیف" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_gif", "گیف")
	elseif ((mr_roo[2] == "text" ) or (mr_roo[2] == "متن" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_text", "متن")
	elseif ((mr_roo[2] == "photo" ) or (mr_roo[2] == "عکس" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_photo", "عکس")
	elseif ((mr_roo[2] == "video" ) or (mr_roo[2] == "فیلم" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_video", "فیلم")
	elseif ((mr_roo[2] == "video_note" ) or (mr_roo[2] == "فیلم سلفی" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_video_note", "فیلم سلفی")
	elseif ((mr_roo[2] == "audio" ) or (mr_roo[2] == "اهنگ" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_audio", "آهنگ")
	elseif ((mr_roo[2] == "voice" ) or (mr_roo[2] == "صدا" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_voice", "صدا")
	elseif ((mr_roo[2] == "sticker" ) or (mr_roo[2] == "استیکر" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_sticker", "استیکر")
	elseif ((mr_roo[2] == "contact" ) or (mr_roo[2] == "مخاطب" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_contact", "مخاطب")
	elseif ((mr_roo[2] == "forward" ) or (mr_roo[2] == "فوروارد" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_forward", "فوروارد")
	elseif ((mr_roo[2] == "location" ) or (mr_roo[2] == "موقعیت" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_location", "موقعیت")
	elseif ((mr_roo[2] == "document" ) or (mr_roo[2] == "فایل" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_document", "فایل")
	elseif ((mr_roo[2] == "tgservice" ) or (mr_roo[2] == "سرویس تلگرام" )) and is_JoinChannel(msg) then
		UnLock_Delmsg(msg, "mute_tgservice", "سرویس-تلگرام")
	elseif ((mr_roo[2] == "inline" ) or (mr_roo[2] == "کیبورد شیشه ای" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_inline", "کیبورد شیشه ای")
	elseif ((mr_roo[2] == "game" ) or (mr_roo[2] == "بازی" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_game", "بازی")
	elseif ((mr_roo[2] == "keyboard" ) or (mr_roo[2] == "صفحه کلید" )) and is_JoinChannel(msg) then
		Unlock_Delmsg(msg, "mute_keyboard", "صفحه کلید")
	elseif ((mr_roo[2] == "cmds" ) or (mr_roo[2] == "دستورات" )) and is_JoinChannel(msg) then
		tdbot.sendMessage(msg.to.id, msg.id, 1, M_START.."`قفل دستورات` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `غیرفعال شد.`"..EndPm, 1, 'md')
		redis:del(RedisIndex.."lock_cmd"..msg.chat_id)
	end
end
--######################################################################--
end

return {
patterns ={"^[!/#](lock) (.*)$","^[!/#](warn) (.*)$","^[!/#](kick) (.*)$","^[!/#](mute) (.*)$","^[!/#](unlock) (.*)$","^([Ll][Oo][Cc][Kk]) (.*)$","^([Ww][Aa][Rr][Nn]) (.*)$","^([Kk][Ii][Cc][Kk]) (.*)$","^([Mm][Uu][Tt][Ee]) (.*)$","^([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",'^(قفل) (.*)$','^(اخطار) (.*)$','^(اخراج) (.*)$','^(سکوت) (.*)$','^(باز کردن) (.*)$','^(بازکردن) (.*)$'},
run = MaTaDoRTeaM
}