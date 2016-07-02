do

function run(msg, matches)
       if not is_momod(msg) then
        return 
       end
    local data = load_data(_config.moderation.data)
      local group_link = data[tostring(msg.to.id)]['settings']['set_link']
       if not group_link then 
      local text =  "اول باید لینک جدید ایجاد کنید"
        reply_msg(msg.id, text, ok_cb, false)
       end
         local text = "لینک گروه:\n"..group_link
          send_large_msg('user#id'..msg.from.id, text, ok_cb, false)
           local text = "لینک به pv ارسال شد"
             reply_msg(msg.id, text, ok_cb, false)
end

return {
  patterns = {
    "^[/#!]([Ll]inkpv)$"
  },
  run = run
}

end
