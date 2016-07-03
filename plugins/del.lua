local function run(msg, matches)
if matches[1]:lower() == 'del' then 
      if not is_sudo(msg) then
        return 
      end
if matches[2] == 'gbanlist' then
local hash = 'gbanned'
send_large_msg(get_receiver(msg), "لیست سوپر بن پاک شد.")
redis:del(hash)
     end
end
if matches[1]:lower() == 'del' then
if not is_owner(msg) then
return 
end
if matches[2] == 'banlist' then
local chat_id = msg.to.id
local hash = 'banned:'..chat_id
send_large_msg(get_receiver(msg), "لیست بن پاک شد.")
redis:del(hash)
end
end
 end

return {
  patterns = {
  "[!/#]([Dd]el) (.*)$",
  "([Dd]el) (.*)$",
  },
  run = solid
}

-- Maked By @SoLiD021(جقی بیش نیست)
