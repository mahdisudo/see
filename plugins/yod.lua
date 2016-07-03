
do
function run(msg, matches)
if is_owner(msg) then
local pic = {
"yod1",
"yod2",
"yod3",
"yod4",
"yod5",
"yod6",
"yod7",
"yod8",
"yod9",
"yod10",
"yod11",
"yod12",
"yod13",
"yod14",
"yod15",
"yod16",
"yod17",
"yod18",
"yod19",
"yod20",
"yod21",
"yod22",
"yod23",
"yod24",
"yod25",
"yod26",
"yod27",
"yod28",
"yod29",
"yod30",
"yod31",
"yod32",
"yod33",
"yod34",
"yod35",
"yod36",
"yod37",
"yod38",
"yod39",
"yod40",
"yod41",
"yod42",
"yod43",
"yod44",
"yod45",


}
local randoms = pic[math.random(#pic)]
local randomd = randoms..".jpg"
local cb_extra = {file_path=file}
local receiver = get_receiver(msg)
local file = "yodaa/"..randomd
 send_photo(receiver, file, rmtmp_cb, cb_extra)
 end

end
return {
  patterns = {

	"^yod$",
	"^[!#/]yod"
  },
  run = run
}

end
