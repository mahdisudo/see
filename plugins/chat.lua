local function run(msg, matches)
if is_owner(msg) then 
return 
end
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
            if data[tostring(msg.to.id)]['settings']['chat'] then
                lock_chat = data[tostring(msg.to.id)]['settings']['chat']
            end
        end
    end
    local chat = get_receiver(msg)
    local user = "user#id"..msg.from.id
if matches[1] == "hi"  and lock_chat == "yes" then
  return "این ادم سلام بده کوکسش"
end
if matches[1] == "Khubi"  and lock_chat == "yes" then
  return "جق نزن کور میشی"
end
if matches[1] == "Salam"  and lock_chat == "yes"  then
  return "سرت توی کلام"
end
if matches[1] == "rokh"  and lock_chat == "yes" then
  return "itsssssssssssssssssssssssssssssssssssssssssssssssss best bk"
end
if matches[1] == "bot"  and lock_chat == "yes" then
  return "بده بکنیم"
end
if matches[1] == "چته"  and lock_chat == "yes" then
  return "می خوام بکنمت"
end
if matches[1] == "خوبین"  and lock_chat == "yes" then
 return "مرسی عزیزم"
end
if matches[1] == "bye"  and lock_chat == "yes" then
  return "تو کونت"
end
if matches[1] == "سلام"  and lock_chat == "yes" then
    return "سرت تو کون مش غلام"
end
if matches[1] == "سلام"  and  is_sudo(msg) then
    return "سلام بکن بچه های ساپورت"
end
if matches[1] == "koskesh"  and lock_chat == "yes" then
  return "کیسه بکش"
end
if matches[1] == "kir"  and lock_chat == "yes" then
  return "از داشته هات بحرف دفعه بعد کیک"
end
if matches[1] == "کونی"  and lock_chat == "yes" then
  return "شب روزنامه می خونی"
end
if matches[1] == "جنده"  and lock_chat == "yes" then
  return "جنده دوست"
end
if matches[1] == "سیکتیر"  and lock_chat == "yes" then
  return "قرارمون یادت نره سی یک تیر بریم پشت باغ"
end
if matches[1] == "اه"  and lock_chat == "yes" then
  return "جوون دردت اومد"
end
if matches[1] == "کیر"  and lock_chat == "yes" then
  return "بخواب بیاد به خوابت"
end
if matches[1] == "عشقم"  and lock_chat == "yes" then
  return "به کون تو تشنم"
end
if matches[1] == "عزیزم"  and lock_chat == "yes" then
  return " راه را برای کسلسانباز کنیم کسلیس اول"
end
if matches[1] == "وای"  and lock_chat == "yes" then
  return "برو تو  کوچه تا من بیام"
end
if matches[1] == "slm"  and lock_chat == "yes" then
  return "سلام گشاد عزیز حالت چطوره"
end
if matches[1] == "pv"  and lock_chat == "yes" then
  return "بیا پی وی بحرفیم"
end
if matches[1] == "اصل"  and lock_chat == "yes" then
  return "رخ 16 رشت"
end
if matches[1] == "سکسی"  and lock_chat == "yes" then
  return "ابم اومد دوباره"
end
if matches[1] == "تتلو"  and lock_chat == "yes" then
  return "ساسی مانکن پروداکششششن"
end
if matches[1] == "تهران"  and lock_chat == "yes" then
  return "میساکی برام تا تهران"
end
if matches[1] == "دولا"  and lock_chat == "yes" then
  return "سرت تو کون ملا"
end
if matches[1] == "الو"  and lock_chat == "yes" then
  return "نزن گور میشی"
end
if matches[1] == "کی"  and lock_chat == "yes" then
  return "الکسیس"
end
if matches[1] == "لایبر"  and lock_chat == "yes" then
  return "مای سان"
end
if matches[1] == "امبرلا"  and lock_chat == "yes" then
  return "گی بدبخت"
end
if matches[1] == "جق"  and lock_chat == "yes" then
  return "به یادتم شب"
end
if matches[1] == "مهران"  and lock_chat == "yes" then
  return " ساک بزن تا تهران"
end
if matches[1] == "بهراد"  and lock_chat == "yes" then
  return "برو کنار باد بیاد"
end
if matches[1] == "lua"  and lock_chat == "yes" then
  return "لای یور عمت"
end
if matches[1] == "پت"  and lock_chat == "yes" then
  return "عمت کرد مت"
end
if matches[1] == "رشت"  and lock_chat == "yes" then
  return "کیر تو کونت گشت"
end
if matches[1] == "ایران"  and lock_chat == "yes" then
  return "میکنمت تا کست بشه ویران"
end
if matches[1] == "مادرجنده"  and lock_chat == "yes" then
  return "پینوکیو ننت گایید"
end
if matches[1] == "حرام"  and lock_chat == "yes" then
  return "حرام است"
end
if matches[1] == "سخن"  and lock_chat == "yes" then
  return "امام خمینی"
end
if matches[1] == "کیه"  and lock_chat == "yes" then
  return "حاممممممد پهههههلان"
end 
if matches[1] == "جانی"  and lock_chat == "yes" then
  return "خاطرات یک کون"
end
if matches[1] == "ربات"  and lock_chat == "yes" then
  return "کیرم تو کون لات"
end
if matches[1] == "دختر"  and lock_chat == "yes" then
  return "طبیعی باش"
end
if matches[1] == "شماره"  and lock_chat == "yes" then
  return "بیا پی وی من اونوووو ولش"
end
if matches[1] == "لا "  and lock_chat == "yes" then
  return "زشت پسرم"
end
if matches[1] == "جوجو"  and lock_chat == "yes" then
  return "جیک جیک سیک "
end
if matches[1] == "اتحاد"  and lock_chat == "yes" then
  return "به کیرم"
end
if matches[1] ==  "داری"  and lock_chat == "yes" then
  return "نداشتم نبودی"
end
if matches[1] == "دعوا"  and lock_chat == "yes" then
  return "کیرم بگیر برپا"
end
if matches[1] == "نگا"  and lock_chat == "yes" then
  return "کون سفید"
end
if matches[1] == "عمه"  and lock_chat == "yes" then
  return "عمه بنیاد خانواده"
end
if matches[1] == "دیگه"  and lock_chat == "yes" then
  return "رفتی "
end
if matches[1] == "اهنگ"  and lock_chat == "yes" then
  return "شماره عمت یادم رفت"
end
if matches[1] == "میدم"  and lock_chat == "yes" then
  return "به قریبه میدی به ما نمی دی برا ما خار داره"
end
if matches[1] == "کس ننت"  and lock_chat == "yes" then
  return "من گایییدم کلا خطر"
end
if matches[1] == "رپر"  and lock_chat == "yes" then
  return "رپر فقط شماییل زاده"
end
if matches[1] == "کییر"  and lock_chat == "yes" then
  return "از خدا بخا از من بگیر"
end
if matches[1] == "مخ"  and lock_chat == "yes" then
  return "بی\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nنام نشان"
end
if matches[1] == "رخ"  and lock_chat == "yes" then
  return "صد ساک"
end
if matches[1] == "سوپر"  and lock_chat == "yes" then
  return "بدبخت جقیی پدر مادرت خبر دارن اینقدر منحرفی "
end
if matches[1] == "بیا"  and lock_chat == "yes" then
  return "بازم بکنمت"
end
if matches[1] == "فردا"  and lock_chat == "yes" then
  return "یه فیلم سوپر یههه فیلم سوپر"
end
if matches[1] == "دیوث"  and lock_chat == "yes" then
  return "سرش ببوس"
end
if matches[1] == "کردمت"  and lock_chat == "yes" then
  return "تو هم که هر دفعه ما رو می بینی پریودی"
end
if matches[1] == "اشرار"  and lock_chat == "yes" then
  return "سللام من برسوون"
end
if matches[1] == "بی ناموس"  and lock_chat == "yes" then
  return "اختاپپوس"
end
if matches[1] == "پلاگین"  and lock_chat == "yes" then
  return "بگاییین ؟"
end
if matches[1] == "خرداد"  and lock_chat == "yes" then
  return "عمت گس داد"
end
if matches[1] == "رخ داد"  and lock_chat == "yes" then
  return "رخ اینجا اونجا همه جا"
end
if matches[1] == "بر"  and lock_chat == "yes" then
  return "برو تو کوچه تا من بیام"
end

if matches[1] == "بلا"  and lock_chat == "yes" then
  return "چطوری کون طلا"
end
if matches[1] == "بکن"  and lock_chat == "yes" then
  return "اگه ما بکن نبودیم شما جنده نبودی"
end
if matches[1] == "امیر"  and lock_chat == "yes" then
  return "کیرم بگییر بمیر"
end
if matches[1] == "سلم"  and lock_chat == "yes" then
  return "کیرمو بخور "
end
if matches[1] == "من"  and lock_chat == "yes" then
  return "درد میکنه نخم چپم"
end
if matches[1] == "کس"  and lock_chat == "yes" then
  return "نلیس برادر"
end
if matches[1] == "کونی"  and lock_chat == "yes" then
  return "کردمت تو گونی"
end
if matches[1] == "علی دایی"  and lock_chat == "yes" then
  return "اوه شطط ابم اومد"
end
if matches[1] == "تلگرام"  and lock_chat == "yes" then
  return "کرم لات"
end
if matches[1] == "احمد"  and lock_chat == "yes" then
  return "سیبیل بگیر گوز امد"
end
if matches[1] == "فیلم"  and lock_chat == "yes" then
  return "سوپپپپر دوس"
end
if matches[1] == "sbss"  and lock_chat == "yes" then
  return "یک ربات جقی"
end
if matches[1] == "بد بختا"  and lock_chat == "yes" then
  return "پچه بازم"
end
if matches[1] == "کیل"  and lock_chat == "yes" then
  return "تو کونت بگیر بمیر"
end
if matches[1] == "من"  and lock_chat == "yes" then
  return "زیدتم ساک زد برام تو وان با کفش"
end
if matches[1] == "پسرم"  and lock_chat == "yes" then
  return "رخ بات یه ترویستین که با شعراش جق میزنه "
end
if matches[1] == "نگا"  and lock_chat == "yes" then
  return "اسپره زدی نمی خوام"
end
if matches[1] == "جان"  and lock_chat == "yes" then
  return "بعضی وقتا میری تو لک میزنی یه جق بعد میریزی رو تخت "
end
if matches[1] == "فاک"  and lock_chat == "yes" then
  return "کی دوقلو زایید"
end
if matches[1] == "گشاد"  and lock_chat == "yes" then
  return "کیر تو کون گشت ارشاد"
end
if matches[1] == "پلیس"  and lock_chat == "yes" then
  return  "پرا ما جقیا شدیم اینجا خطر ناک اشکال از ریشست" 
end
if matches[1] == "فاطمه"  and lock_chat == "yes" then
  return "به کیرم بده خاتمه"
end
if matches[1] == "بسه"  and lock_chat == "yes" then
  return "سرش بگیر نشو خسته"
end
if matches[1] == "پایدار"  and lock_chat == "yes" then
  return "کیرم تو کونت تا پای دار"
end
if matches[1] == "پیشرو"  and lock_chat == "yes" then
  return "کیرم بخور بدون در رو"
end
if matches[1] == "راهنما"  and lock_chat == "yes" then
  return "بده بککنیم"
end
if matches[1] == "لاس"  and lock_chat == "yes" then
  return "سیکتیر"
end
if matches[1] == "هو"  and lock_chat == "yes" then
  return "کیر تو کونت ووی"
end
if matches[1] == "ناموسن"  and lock_chat == "yes" then
  return "ننت با با بام چالوسن"
end
if matches[1] == "شایان"  and lock_chat == "yes" then
  return "کس ننه شایان احمدی"
end
if matches[1] == "انبرلا"  and lock_chat == "yes" then
  return "من مادرشو گاییدم"
end
if matches[1] == "خستم"  and lock_chat == "yes" then
  return "بده بکنیم"
end
end
 
return {
  patterns = {
  "hi",  
"Khubi",  
"Salam",  
"rokh",  
"bot",  
"چته",  
"خوبین",  
"bye",  
"سلام",  
"koskesh",  
"kir",  
"کونی",  
"جنده",  
"سیکتیر",  
"اه",  
"کیر",  
"عشقم",  
"عزیزم",  
"وای",  
"slm",  
"pv",  
"اصل",  
"سکسی",  
"تتلو",  
"تهران",  
"دولا",  
"الو",  
"کی",  
"لایبر",  
"امبرلا",  
"جق",  
"مهران",  
"بهراد",  
"lua",  
"پت",  
"رشت",  
"ایران",  
"مادرجنده",  
"حرام",  
"سخن",  
"کیه",  
"جانی",  
"ربات",  
"دختر",  
"شماره",  
"لا ",  
"جوجو",  
"اتحاد",  
"داری",
"دعوا",  
"نگا",  
"عمه",  
"دیگه",  
"اهنگ",  
"میدم",  
"کس ننت",  
"رپر",  
"کییر",  
"مخ",  
"رخ",  
"سوپر",  
"بیا",  
"فردا",  
"دیوث",  
"کردمت",  
"اشرار",  
"بی ناموس",  
"پلاگین",  
"خرداد",  
"رخ داد",  
"بر",  
"بلا",  
"بکن",  
"امیر",  
"سلم",  
"من",  
"کس",  
"کونی",  
"علی دایی",  
"تلگرام",  
"احمد",  
"فیلم",  
"sbss",  
"بد بختا",  
"کیل",  
"من",  
"پسرم",  
"نگا",  
"جان",  
"فاک",  
"گشاد",  
"پلیس",  
"فاطمه",  
"بسه"
  },
  run = run
}
