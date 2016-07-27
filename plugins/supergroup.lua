
local function addword(msg, name)
    local hash = 'chat:'..msg.to.id..':badword'
    redis:hset(hash, name, 'newword')
    return "کلمه جدید به فیلتر کلمات اضافه شد\n>"..name
end

local function get_variables_hash(msg)

    return 'chat:'..msg.to.id..':badword'

end 

function clear_commandbad(msg, var_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:del(hash, var_name)
  return 'پاک شدند'
end

local function list_variables2(msg, value)
  local hash = get_variables_hash(msg)
  
  if hash then
    local names = redis:hkeys(hash)
    local text = ''
    for i=1, #names do
	if string.match(value, names[i]) and not is_momod(msg) then
	if msg.to.type == 'channel' then
	delete_msg(msg.id,ok_cb,false)
	else
	kick_user(msg.from.id, msg.to.id)

	end
return 
end
      
    end
  end
end
local function get_valuebad(msg, var_name)
  local hash = get_variables_hash(msg)
  if hash then
    local value = redis:hget(hash, var_name)
    if not value then
      return
    else
      return value
    end
  end
end
function clear_commandsbad(msg, cmd_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:hdel(hash, cmd_name)
  return ''..cmd_name..'  پاک شد'
end
local function list_variablesbad(msg)
  local hash = get_variables_hash(msg)

  if hash then
    local names = redis:hkeys(hash)
    local text = '\n.'
    for i=1, #names do
      text = text..'>'..names[i]..'\n'
    end
    return text
	else
	return 
  end
end 

local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "Promote me to admin first!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "no",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_sticker = 'no',
		  member = 'no',
		  public = 'no',
		  lock_rtl = 'no',
		  lock_tgservice = 'yes',
		  lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = '✠سوپر گروه با موفقیت ثبت شد✠'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = '🚫سوپر گروه از لیست حذف شد🚫'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1 
	end
	
    send_large_msg(cb_extra.receiver, text)
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="📝اطلاعات سوپر گروه: ["..result.title.."]\n\n"
local admin_num = "👤تعداد ادمین: "..result.admins_count.."\n"
local user_num = "👤تعداد یوزرنیم: "..result.participants_count.."\n"
local kicked_num = "👤تعداد افراد حذف شده: "..result.kicked_count.."\n"
local channel_id = "👤ایدی: "..result.peer_id.."\n"
if result.username then
	channel_username = "🚕یوزرنیم: @"..result.username
else
	channel_username = "-"
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
   reply_msg(msg.id, text, ok_cb, false)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_normal(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_mod_lock = data[tostring(target)]['settings']['lock_mod']
  if group_mod_lock == 'yes' then
    local text = 'normal'
	   reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_mod'] = 'normal'
    save_data(_config.moderation.data, data)
    local text = 'normal'
	   reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_ethad(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_mod_lock = data[tostring(target)]['settings']['lock_mod']
  if group_mod_lock == 'ethad' then
     local text = 'ethad'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_mod'] = 'ethad'
    save_data(_config.moderation.data, data)
     local text = 'ethad'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_family(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_mod_lock = data[tostring(target)]['settings']['lock-mod']
  if group_mod_lock == 'family' then
     local text = 'family'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_mod'] = 'family'
    save_data(_config.moderation.data, data)
     local text = 'family'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
     local text = 'Link posting is already locked'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Link posting has been locked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
     local text = 'Link posting is not locked'
     reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Link posting has been unlocked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'yes' then
     local text = 'all setting is already locked'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'all setting has been locked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
     local text = 'all setting is not locked'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'all setting has been unlocked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == 'yes' then
     local text = 'etehad setting is already locked'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['etehad'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'etehad setting has been locked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == 'no' then
    local text = 'etehad setting is not locked'
	   reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['etehad'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'etehad setting has been unlocked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == 'yes' then
     local text = 'leave is already locked'
	    reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['leave'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'leave has been locked'
	    reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == 'no' then
     local text = 'leave is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['leave'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'leave has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'yes' then
     local text = 'operator is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['operator'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'operator has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'no' then
     local text = 'operator is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['operator'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'operator has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'yes' then
     local text = 'reply is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['reply'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'reply has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
	 
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'no' then
     local text = 'reply is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['reply'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'reply has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'yes' then
     local text = 'username is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['username'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'username has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'no' then
     local text = 'username is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['username'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'username has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'yes' then
     local text = 'media is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['media'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'media has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'no' then
     local text = 'media is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['media'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'media has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == 'yes' then
     local text = 'fosh is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fosh'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'fosh has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == 'no' then
     local text = 'fosh is not locked'
	reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fosh'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'fosh has been unlocked'
	reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['join']
  if group_join_lock == 'yes' then
     local text = 'join is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['join'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'join has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['join']
  if group_join_lock == 'no' then
     local text = 'join is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['join'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'join has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'yes' then
     local text = 'fwd is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fwd'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'fwd has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'no' then
     local text = 'fwd is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fwd'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'fwd has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'yes' then
     local text = 'english is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['english'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'english has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'no' then
     local text = 'english is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['english'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'english has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_welcome(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_welcome_lock = data[tostring(target)]['settings']['welcome']
  if group_welcome_lock == 'yes' then
     local text = 'welcome is already on'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['welcome'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'welcome has been on'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_welcome(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_welcome_lock = data[tostring(target)]['settings']['welcome']
  if group_welcome_lock == 'no' then
     local text = 'welcome is off'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['welcome'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'welcome has been off'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'yes' then
     local text = 'emoji is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['emoji'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'emoji has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'no' then
     local text = 'emoji is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['emoji'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'emoji has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'yes' then
     local text = 'tag is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['tag'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'tag has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'no' then
     local text = 'tag is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['tag'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'tag has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
     local text = 'all setting is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'all setting has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return "Owners only!"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
     local text = 'SuperGroup spam is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'SuperGroup spam has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
     local text = 'SuperGroup spam is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'SuperGroup spam has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
     local text = 'Flood is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Flood has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
     local text = 'Flood is not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Flood has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
     local text = 'Arabic is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Arabic has been locked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
     local text = 'Arabic/Persian is already unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Arabic/Persian has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end


local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
     local text = 'SuperGroup members are already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
   local text = 'SuperGroup members has been locked'
   reply_msg(msg.id, text, ok_cb, false)
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
     local text = 'SuperGroup members are not locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'SuperGroup members has been unlocked'
	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
     local text = 'RTl is already locked'
	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'RTL has been locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
     local text = 'RTL is already unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'RTL has been unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
     local text = 'Tgservice is already locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Tgservice has been locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
     local text = 'TgService Is Not Locked!'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Tgservice has been unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
     local text = 'Sticker posting is already locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Sticker posting has been locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
     local text = 'Sticker posting is already unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Sticker posting has been unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
     local text = 'Bots protection is already enabled'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Bots protection has been enabled'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end
local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
     local text = 'Bots protection is already disabled'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Bots protection has been disabled'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_chat(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_chat_lock = data[tostring(target)]['settings']['chat']
  if group_chat_lock == 'yes' then
     local text = 'chat is enable'
	 	 reply_msg(msg.id, text, ok_cb, false)
		 
  else
    data[tostring(target)]['settings']['chat'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'chat already enable'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_chat(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_chat_lock = data[tostring(target)]['settings']['chat']
  if group_chat_lock == 'no' then
     local text = 'chat is already off'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['chat'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'chat disable'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
     local text = 'Contact posting is already locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Contact posting has been locked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
     local text = 'Contact posting is already unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Contact posting has been unlocked'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
     local text = 'Settings are already strictly enforced'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
     local text = 'Settings will be strictly enforced'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
     local text = 'Settings are not strictly enforced'
	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
     local text = 'Settings will not be strictly enforced'
	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end
--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
   local text = 'SuperGroup rules set'
   	 	 reply_msg(msg.id, text, ok_cb, false)
   
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    local text = 'No rules available.'
	reply_msg(msg.id, text, ok_cb, false)
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' rules:\n\n'..rules:gsub("/n", " ")
  local text = rules
  	 	 reply_msg(msg.id, text, ok_cb, false)
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "For moderators only!"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
     local text = 'Group is already public'
	 	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
   local text = 'SuperGroup is now: public'
   	 	 reply_msg(msg.id, text, ok_cb, false)
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
     local text = 'Group is not public'
	 	 	 reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
     local text = 'SuperGroup is now: not public'
	 	 	 reply_msg(msg.id, text, ok_cb, false)
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 85
      	end
    end
    local bots_protection = "Yes"
    if data[tostring(target)]['settings']['lock_bots'] then
    	bots_protection = data[tostring(target)]['settings']['lock_bots']
   	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
        end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['tag'] then
			data[tostring(target)]['settings']['tag'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['emoji'] then
			data[tostring(target)]['settings']['emoji'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['english'] then
			data[tostring(target)]['settings']['english'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fwd'] then
			data[tostring(target)]['settings']['fwd'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['reply'] then
			data[tostring(target)]['settings']['reply'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['join'] then
			data[tostring(target)]['settings']['join'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fosh'] then
			data[tostring(target)]['settings']['fosh'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['username'] then
			data[tostring(target)]['settings']['username'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['media'] then
			data[tostring(target)]['settings']['media'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['leave'] then
			data[tostring(target)]['settings']['leave'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['all'] then
			data[tostring(target)]['settings']['all'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['operator'] then
			data[tostring(target)]['settings']['operator'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['etehad'] then
			data[tostring(target)]['settings']['etehad'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['welcome'] then
			data[tostring(target)]['settings']['welcome'] = 'no'
					end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['chat'] then
			data[tostring(target)]['settings']['chat'] = 'no'
					end				
	 end
	 	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_mod'] then
			data[tostring(target)]['settings']['lock_mod'] = 'normal'
					end				
	 end
  local gp_type = data[tostring(msg.to.id)]['group_type']
  
  local settings = data[tostring(target)]['settings']
 -- local text = "تنظیمات سوپرگروه:⬇️\n\n🔧قفل لینک: "..settings.lock_link.."\n🔧قفل شماره: "..settings.lock_contacts.."\n🔧قفل فلود: "..settings.flood.."\n🔧حساسیت: "..NUM_MSG_MAX.."\n🔧قفل اسپم: "..settings.lock_spam.."\n🔧قفل عربی و فارسی: "..settings.lock_arabic.."\n🔧قفل اعضا: "..settings.lock_member.."\n🔧RTL قفل: "..settings.lock_rtl.."\n🔧Tgservice قفل: "..settings.lock_tgservice.."\n🔧قفل استیکر: "..settings.lock_sticker.."\n🔧قفل تگ(#): "..settings.tag.."\n🔧قفل اموجی: "..settings.emoji.."\n🔧قفل اموجی: "..settings.english.."\n🔧قفل فرواد: "..settings.fwd.."\n🔧قفل ریپلی: "..settings.reply.."\n🔧قفل جوین: "..settings.join.."\n🔧قفل یوزرنیم(@): "..settings.username.."\n🔧media قفل: "..settings.media.."\n🔧قفل فحش: "..settings.fosh.."\n🔧قفل لفت: "..settings.leave.."\n🔧قفل ربات: "..bots_protection.."\n🔧operatorقفل: "..settings.operator.."\n\n⚙تنظیمات اسان وشیرن:⬇️\n\n>سوئچ گروه: "..settings.etehad.."\n🔧قفل همه: "..settings.all.."\n\nℹ️درباره گروهℹ️:⬇️\n\n🎯نوع گروه: "..gp_type.."\n🎯حالت عمومی: "..settings.public.."\n🎯تنظیمات دقیق: "..settings.strict.."\n\n\n@Hacker_Team"
   local text =  mutes_list(msg.to.id)
  local text =  text.."#"..settings.lock_link.." lock links: "..settings.lock_link.."\n"
  local text =  text.."#"..settings.lock_link.." lock contact: "..settings.lock_link.."\n"
  local text =  text.."#"..settings.flood.." lock flood: "..settings.flood.."\n"
  local text =  text.."👥flood : "..NUM_MSG_MAX.."\n"
  local text =  text.."#"..settings.lock_spam.." lang name (spam): "..settings.lock_spam.."\n"
  local text =  text.."#"..settings.lock_arabic.." lock arabic: "..settings.lock_arabic.."\n"
  local text =  text.."#"..settings.lock_member.." lock member: "..settings.lock_member.."\n"
  local text =  text.."#"..settings.lock_rtl.." lock RTL : "..settings.lock_rtl.."\n"
  local text =  text.."#"..settings.lock_tgservice.." lock tgservice : "..settings.lock_tgservice.."\n"
  local text =  text.."#"..settings.lock_sticker.."lock stickers: "..settings.lock_sticker.."\n"
  local text =  text.."#"..settings.tag.."lock tag(#): "..settings.tag.."\n"
  local text =  text.."#"..settings.username.." lock username(@): "..settings.username.."\n"
  local text =  text.."#"..settings.english.." lock english: "..settings.english.."\n"
  local text =  text.."#"..settings.fwd.."lock fwd: "..settings.fwd.."\n"
  local text =  text.."#"..settings.fosh.." lock fosh: "..settings.fosh.."\n"
  local text =  text..""..bots_protection.." lock bots: "..bots_protection.."\n"
  local text =  text.."\n📚 AboutGroup :\n📚 GroupModel : "..gp_type.."\n📚 Public: "..settings.public
  local text = text.."\n📚 Strict: "..settings.strict.."\n📚 Switch: "..settings.lock_mod.."\n📚 BotSettings \n📚 Chat: "..settings.chat.."\n📚 Welcome:"..settings.welcome.."\n"
	if string.match(text, 'normal') then text = string.gsub(text, 'normal', 'Nomal') end
	if string.match(text, 'no') then text = string.gsub(text, 'no', '🔓') end
	if string.match(text, 'yes') then text = string.gsub(text, 'yes', '🔒') end
	if string.match(text, '0') then text = string.gsub(text, '0', '0') end
	if string.match(text, '1') then text = string.gsub(text, '1', '1') end
	if string.match(text, '2') then text = string.gsub(text, '2', '2') end
	if string.match(text, '3') then text = string.gsub(text, '3', '3') end
	if string.match(text, '4') then text = string.gsub(text, '4', '4') end
	if string.match(text, '5') then text = string.gsub(text, '5', '5') end 
	if string.match(text, '6') then text = string.gsub(text, '6', '6') end
	if string.match(text, '7') then text = string.gsub(text, '7', '7') end
	if string.match(text, '8') then text = string.gsub(text, '8', '8') end
	if string.match(text, '9') then text = string.gsub(text, '9', '9') end
	if string.match(text, 'public: 🔒') then text = string.gsub(text, 'public: 🔒', 'public: ⛔️') end
	if string.match(text, 'public: 🔓') then text = string.gsub(text, 'public: 🔓', 'public: ⛔️') end
	if string.match(text, '#🔓') then text = string.gsub(text, '#🔓', '👥') end
	if string.match(text, '#🔒') then text = string.gsub(text, '#🔒', '👥') end
	if string.match(text, 'Mutes for:') then text = string.gsub(text, 'Mutes for:', 'SuperGroup Settings') end
	if string.match(text, 'Mute') then text = string.gsub(text, 'Mute', 'lock') end
  reply_msg(msg.id, text, ok_cb, false)
end
--wel
local function set_welcomemod(msg, data, target)
      if not is_momod(msg) then
        return "شما مدیر گروه نیستید"
      end
  local data_cat = 'welcome_msg'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'پیام خوش امد گویی :\n'..rules..'\n---------------\nبرای نمایش نام کاربر و نام گروه یا قوانین  میتوانید به صورت زیر عمل کنید\n\n /set welcome salam {name} be goroohe {group} khosh amadid \n ghavanine gorooh: {rules} \n\nربات به صورت هوشمند نام گروه , نام کاربر و قوانین را به جای {name}و{group} و {rules} اضافه میکند.'
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' is not a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, 'SuperGroup is not added.')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' has been promoted.')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' is not a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' has been demoted.')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
     local text = 'SuperGroup is not added.'
	 reply_msg(msg.id, text, ok_cb, false)
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
     local text = 'No moderator in this group.'
	 reply_msg(msg.id, text, ok_cb, false)
  end
  local i = 1
  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." set as an admin"
		else
			text = "[ "..user_id.." ]set as an admin"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "You can't demote global admins!")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." has been demoted from admin"
		else
			text = "[ "..user_id.." ] has been demoted from admin"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "@"..result.from.username.." [ "..result.from.peer_id.." ] added as owner"
			else
				text = "[ "..result.from.peer_id.." ] added as owner"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..user_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] removed from the muted user list")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] added to the muted user list")
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "You can't demote global admins!")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(receiver, text)
		else
			text = "[ "..result.peer_id.." ] has been demoted from admin"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)

	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "You can't demote global admins!")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been demoted from admin"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] removed from muted user list")
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] added to muted user list")
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'No user @'..member..' in this SuperGroup.'
  else
    text = 'No user ['..memberid..'] in this SuperGroup.'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "@"..v.username.." ["..v.peer_id.."] has been set as an admin"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "["..v.peer_id.."] has been set as an admin"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
					text = member_username.." ["..v.peer_id.."] added as owner"
				else
					text = "["..v.peer_id.."] added as owner"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "["..memberid.."] added as owner"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

--Run function
local function run(msg, matches)

	if msg.to.type == 'chat' then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local text = "Already a SuperGroup"
							reply_msg(msg.id, text, ok_cb, false)
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1] == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return reply_msg(msg.id, 'SuperGroup is already added.', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1] == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, 'SuperGroup is not added.', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
		if matches[1] == "gpinfo" then
			if not is_owner(msg) then
				return
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				local text = "no owner,ask admins in support groups to set owner for your SuperGroup"
				reply_msg(msg.id, text, ok_cb, false)
				
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			local text = "SuperGroup owner is ["..group_owner..']'
			reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == "modlist" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			local text = modlist(msg)
			reply_msg(msg.id, text, ok_cb, false)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" and is_momod(msg) then
			member_type = 'Bots'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kicked" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'block' or matches[1] == 'kick' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'block' or matches[1] == 'kick' and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				local text = "\n👤your id: "..msg.from.id.."\n\n👥Group id "..msg.to.id
				reply_msg(msg.id, text, ok_cb, false)
			end
		end

		if matches[1] == 'kickme' then
			if msg.to.type == 'channel' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, 'هشدار:\n این گپ برای بات نیست مینوانید از این دستور /setlink برای تعویض لینک خود استفاده کنید')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created a new link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			local text = 'لطفا لینک جدید را ارسال کنید'
			reply_msg(msg.id, text, ok_cb, false)
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				local text = "عملیات با موفقیت انجام شد🎭"
				reply_msg(msg.id, text, ok_cb, false)
			end
		end

		if matches[1] == 'link' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				local text = "شما میتوانید بادستور /newlink لینک جدید باسازید"
				reply_msg(msg.id, text, ok_cb, false)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			local text = "لینک سوپرگروه:\n"..group_link
			reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		--[[if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end]]

			if matches[1] == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setadmin' and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setadmin' and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demoteadmin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setowner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "[ "..matches[2].." ] added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				local text = "Only owner/admin can promote"
				reply_msg(msg.id, text, ok_cb, false)
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			local text =  "ok"
			reply_msg(msg.id, text, ok_cb, false)
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			local text =  "ok"
			reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				local text =  "Only owner/support/admin can promote"
				reply_msg(msg.id, text, ok_cb, false)
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "setabout" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			local text = "Description has been set.\n\nSelect the chat again to see the changes."
			reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "SuperGroup username Set.\n\nSelect the chat again to see the changes.")
				elseif success == 0 then
					send_large_msg(receiver, "Failed to set SuperGroup username.\nUsername may already be taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			local text = 'Please send the new group photo now'
				reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == 'clean' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				local text =  "Only owner can clean"
					reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					local text =  'No moderator(s) in this SuperGroup.'
						reply_msg(msg.id, text, ok_cb, false)
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				local text =  'Modlist has been cleaned'
					reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					local text =  "Rules have not been set"
						reply_msg(msg.id, text, ok_cb, false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				local text =  'Rules have been cleaned'
					reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'about' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					local text =  'About is not set'
						reply_msg(msg.id, text, ok_cb, false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				local text =  "About has been cleaned"
					reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'silentlist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				local text =  "silentlist Cleaned"
					reply_msg(msg.id, text, ok_cb, false)
			end
			               if matches[2]:lower() == 'welcome' then
	                        local hash = 'usecommands:'..msg.from.id..':'..msg.to.id
                                redis:incr(hash)
                                rules = matches[3]
                                local target = msg.to.id
                                savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group welcome message to ["..matches[3].."]")
                                return set_welcomemod(msg, data, target)
                        end
			if matches[2] == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
		end

		if matches[1] == 'lock' and is_momod(msg) then
			local target = msg.to.id
			     --[[if matches[2] == 'all' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		lock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		lock_group_contacts(msg, data, target),
		lock_group_english(msg, data, target),
		lock_group_fwd(msg, data, target),
		lock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		lock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		lock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return lock_group_all(msg, data, target), safemode
      end
	     if matches[2] == 'etehad' then
      	local etehad ={
        unlock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return lock_group_etehad(msg, data, target), etehad
      end]]--
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			--[[if matches[2] == 'join' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked join ")
				return lock_group_join(msg, data, target)
			end]]
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tag ")
				return lock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end		    
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end

			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked english")
				return lock_group_english(msg, data, target)
			end
			if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fwd")
				return lock_group_fwd(msg, data, target)
			end
						if matches[2] == 'welcome' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked welcome")
				return lock_group_welcome(msg, data, target)
			end
			--[[if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked reply")
				return lock_group_reply(msg, data, target)
			end
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked emoji")
				return lock_group_emoji(msg, data, target)
			end]]
			if matches[2] == 'fosh' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fosh")
				return lock_group_fosh(msg, data, target)
			end
			--[[if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked media")
				return lock_group_media(msg, data, target)
			end]]
			if matches[2] == 'username' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked username")
				return lock_group_username(msg, data, target)
			end
			if matches[2] == 'leave' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return lock_group_leave(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return lock_group_bots(msg, data, target)
			end
			--[[if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return lock_group_operator(msg, data, target)
			end]]
		end

		if matches[1] == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			    --[[if matches[2] == 'all' then
      	local dsafemode ={
        unlock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		unlock_group_spam(msg, data, target),
		unlock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_all(msg, data, target), dsafemode
      end]]
	  	--[[if matches[2] == 'etehad' then
      	local detehad ={
        lock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_etehad(msg, data, target), detehad
      end]]
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			--[[if matches[2] == 'join' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked join")
				return unlock_group_join(msg, data, target)
			end]]
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tag")
				return unlock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end                   
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked english")
				return unlock_group_english(msg, data, target)
			end
			if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fwd")
				return unlock_group_fwd(msg, data, target)
			end
						if matches[2] == 'welcome' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked welcome")
				return unlock_group_welcome(msg, data, target)
			end
			--[[if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked reply")
				return unlock_group_reply(msg, data, target)
			end
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled emoji")
				return unlock_group_emoji(msg, data, target)
			end]]
			if matches[2] == 'fosh' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fosh")
				return unlock_group_fosh(msg, data, target)
			end
			--[[if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked media")
				return unlock_group_media(msg, data, target)
			end]]
			if matches[2] == 'username' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled username")
				return unlock_group_username(msg, data, target)
			end
			if matches[2] == 'leave' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return unlock_group_leave(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return unlock_group_bots(msg, data, target)
			end
			--[[if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return unlock_group_operator(msg, data, target)
			end]]
		end

		if matches[1] == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 200 then
				local text = "Wrong number,range is [1-200]"
					reply_msg(msg.id, text, ok_cb, false)
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			local text = 'Flood has been set to: '..matches[2]
				reply_msg(msg.id, text, ok_cb, false)
		end
		if matches[1] == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end
if matches[1] == 'chat' and is_momod(msg) then
local target = msg.to.id
				if matches[2] == 'disable' then
				savelog(msg.to.id, name_log.."  chat disable")
				return unlock_group_chat(msg, data, target)
			end
							if matches[2] == 'enable' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] chat enable")
				return lock_group_chat(msg, data, target)
			end
			end
		if matches[1] == 'lock' and is_owner(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." has been muted"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "SuperGroup lock "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." has been lockd"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "SuperGroup lock "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." has been lockd"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "SuperGroup lock "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." have been muted"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "SuperGroup mute "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." have been muted"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "SuperGroup mute "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  msg_type.." has been muted"
						reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text =  "Mute "..msg_type.."  has been enabled"
						reply_msg(msg.id, text, ok_cb, false)
					
				else
					local text =  "Mute "..msg_type.." is already on"
						reply_msg(msg.id, text, ok_cb, false)
				end
			end
		end
		if matches[1] == 'unlock' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  msg_type.." has been unlockd"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute "..msg_type.." is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  msg_type.." has been unmuted"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "lock "..msg_type.." is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  msg_type.." has been unmuted"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "lock "..msg_type.." is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  msg_type.." have been unmuted"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute "..msg_type.." is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  msg_type.." have been unmuted"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute "..msg_type.." is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					local text =  msg_type.." has been unmuted"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute text is already off"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text =  "Mute "..msg_type.." has been disabled"
								reply_msg(msg.id, text, ok_cb, false)
				else
					local text =  "Mute "..msg_type.." is already disabled"
								reply_msg(msg.id, text, ok_cb, false)
				end
			end
		end


		if matches[1] == "silent" or matches[1] == "unsilent" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "silent" or matches[1] == "unsilent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					local text = "["..user_id.."] removed from the muted users list"
								reply_msg(msg.id, text, ok_cb, false)
				elseif is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					local text = "["..user_id.."] added to the muted user list"
	          reply_msg(msg.id, text, ok_cb, false)
				end
			elseif matches[1] == "silent" or matches[1] == "unsilent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end
			if matches[1] == 'group' and is_momod(msg) then
             local target = msg.to.id
				if matches[2] == 'normal' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] chat normal")
				return lock_group_normal(msg, data, target)
			end
			if matches[2] == 'ethad' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] chat ethad")
				return  lock_group_ethad(msg, data, target)
			end
				if matches[2] == 'family' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] chat family")
				return lock_group_family(msg, data, target)
			end
			end 
			
		if matches[1] == "muteslist" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				local text = mutes_list(chat_id)
			reply_msg(msg.id, text, ok_cb, false)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return mutes_list(chat_id)
		end
		if matches[1] == "silentlist" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			local text = muted_user_list(chat_id)
			reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == 'settings' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			local text = show_supergroup_settingsmod(msg, target).."\n"
			local text = text.." "..list_variablesbad(msg)
				if string.match(text, '.>') then text = string.gsub(text, '.>', 'list of filters🔍\n>') end

				reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == 'rules' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1] == 'help' and not is_owner(msg) then
			text = "از دستور  /Superhelp  استفاده کنید!"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp")
			text = super_help()
			reply_msg(msg.id, text, ok_cb, false)

		end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
"^([Aa]dd)$",
	"^([Rr]em)$",
	"^([Mm]ove) (.*)$",
	"^([Gg]pinfo)$",
	"^([Aa]dmins)$",
	"^([Oo]wner)$",
	"^([Mm]odlist)$",
	"^([Bb]ots)$",
	"^([Ww]ho)$",
	"^([Kk]icked)$",
        "^([Bb]lock) (.*)",
	"^([Bb]lock)",
	"^([Kk]ick) (.*)",
	"^([Kk]ick)",
	"^([Tt]osuper)$",
	"^([Ii][Dd])$",
	"^([Ii][Dd]) (.*)$",
	"^([Kk]ickme)$",
	"^([Nn]ewlink)$",
	"^([Ss]etlink)$",
	"^([Ll]ink)$",
	"^([Rr]es) (.*)$",
	"^([Ss]etadmin) (.*)$",
	"^([Ss]etadmin)",
	"^([Dd]emoteadmin) (.*)$",
	"^([Dd]emoteadmin)",
	"^([Ss]etowner) (.*)$",
	"^([Ss]etowner)$",
	"^([Pp]romote) (.*)$",
	"^([Pp]romote)",
	"^([Dd]emote) (.*)$",
	"^([Dd]emote)",
	"^([Ss]etname) (.*)$",
	"^([Ss]etabout) (.*)$",
	"^([Ss]etrules) (.*)$",
	"^([Ss]etphoto)$",
	"^([Ss]etusername) (.*)$",
	"^([Dd]el)$",
	"^([Ll]ock) (.*)$",
	"^([Uu]nlock) (.*)$",
	"^([Mm]ute) ([^%s]+)$",
	"^([Uu]nmute) ([^%s]+)$",
	"^([Ss]ilent)$",
	"^([Ss]ilent) (.*)$",
	"^([Uu]nsilent)$",
	"^([Uu]nsilent) (.*)$",
	"^([Pp]ublic) (.*)$",
	"^([Ss]ettings)$",
	"^([Rr]ules)$",
	"^([Ss]etflood) (%d+)$",
	"^([Cc]lean) (.*)$",
	"^([Hh]elp)$",
	"^([Mm]uteslist)$",
	"^([Ss]ilentlist)$",       
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Rr]em)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]pinfo)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]odlist)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
        "^[#!/]([Bb]lock) (.*)",
	"^[#!/]([Bb]lock)",
	"^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Tt]osuper)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]ickme)$",
	"^[#!/]([Nn]ewlink)$",
	"^[#!/]([Ss]etlink)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]etadmin) (.*)$",
	"^[#!/]([Ss]etadmin)",
	"^[#!/]([Dd]emoteadmin) (.*)$",
	"^[#!/]([Dd]emoteadmin)",
	"^[#!/]([Ss]etowner) (.*)$",
	"^[#!/]([Ss]etowner)$",
	"^[#!/]([Pp]romote) (.*)$",
	"^[#!/]([Pp]romote)",
	"^[#!/]([Dd]emote) (.*)$",
	"^[#!/]([Dd]emote)",
	"^[#!/]([Ss]etname) (.*)$",
	"^[#!/]([Ss]etabout) (.*)$",
	"^[#!/]([Ss]etrules) (.*)$",
	"^[#!/]([Ss]etphoto)$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[#!/]([Dd]el)$",
	"^[#!/]([Ll]ock) (.*)$",
	"^[#!/]([Uu]nlock) (.*)$",
	"^[#!/]([Mm]ute) ([^%s]+)$",
	"^[#!/]([Uu]nmute) ([^%s]+)$",
	"^[#!/]([Ss]ilent)$",
	"^[#!/]([Ss]ilent) (.*)$",
	"^[#!/]([Uu]nsilent)$",
	"^[#!/]([Uu]nsilent) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss]ettings)$",
	"^[#!/]([Rr]ules)$",
	"^[#!/]([Ss]etflood) (%d+)$",
	"^[#!/]([Cc]lean) (.*)$",
	"^[#!/]([Hh]elp)$",
	"^[#!/]([Mm]uteslist)$",
	"^[#!/]([Ss]ilentlist)$",
        "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
    "^(https://telegram.me/joinchat/%S+)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
	"^[#!/]([Cc]hat) (.+)$",
    "^group (.*)",
	"^[#!/](group) (.*)"
  },
  run = run,
  pre_process = pre_process
}

