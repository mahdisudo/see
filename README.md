# [Part-tg](https://github.com/behradhg/Prat_tg)


##for run bot
# Installation

```sh
# Install dependencies.
# Tested on Ubuntu 14.04. For other OSs, check out https://github.com/yagop/telegram-bot/wiki/Installation
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev
cd $HOME #if you useing c9
git clone https://github.com/behradhg/Prat_tg
cd Part_tg
chmod +x launch.sh
./launch.sh install
./launch.sh # Enter a phone number & confirmation code.
#For use seady.sh 

killall screen
killall telegram-cli
sudo apt-get install tmux screen

#for screen steady

killall screen
killall telegram-cli
killall tmux
screen bash steady.sh -s

```
### One command
To install everything in one command (useful for VPS deployment) on Debian-based distros, use:
```sh
#https://github.com/yagop/telegram-bot/wiki/Installation
sudo apt-get update; sudo apt-get upgrade -y --force-yes; sudo apt-get dist-upgrade -y --force-yes; sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev libjansson* libpython-dev make unzip git redis-server g++ autoconf -y --force-yes && git clone https://github.com/SEEDTEAM/TeleSeed.git -b supergroups && cd TeleSeed && chmod +x launch.sh && ./launch.sh install && ./launch.sh
```

* * *

### Realm configuration

After you run the bot for first time, send it `!id`. Get your ID and stop the bot.

Open ./data/config.lua and add your ID to the "sudo_users" section in the following format:
```
  sudo_users = {
    110626080,
    103649648,
    111020322,
    0,
    YourID
  }
```
Then restart the bot.

Create a realm using the `!createrealm` command.

* * *

**Creating a LOG SuperGroup**
	-For GBan Log

	1. Create a group using the `!creategroup` command.
	2. Add two members or bots, then use `#Tosuper` to convert to a SuperSroup.
	3. Use the `#addlog` command and your ***LOG SuperGroup(s)*** will be set.
	Note: you can set multiple Log SuperGroups

* * *

# Support and development

Check out this [tutorial by Telegram Geeks](http://telegramgeeks.com/2016/01/teleseed-tutorial/) for further assistance with setup and installation.

**Do not contact us** in private for support.
Join our bot development group by sending `/join 1047524697` to [@TeleSeed](https://telegram.me/TeleSeed)

# Special thanks to
[@seyedan25](https://telegram.me/seyedan25)

For managing [@teleseed](https://telegram.me/TeleSeed) on Telegram.

[@Vamptacus](https://telegram.me/Vamptacus)

For graphic designs.

[topkecleon](https://github.com/topkecleon)

[Juan Potato](https://github.com/JuanPotato)

* * *

# Our team!

[Alphonse](https://github.com/hmon) ([Telegram](https://telegram.me/iwals))

[I M /-\ N](https://github.com/imandaneshi) ([Telegram](https://telegram.me/imandaneshi))

[Siyanew](https://github.com/Siyanew) ([Telegram](https://telegram.me/Siyanew))

[Rondoozle](https://github.com/Rondoozle) ([Telegram](https://telegram.me/POTUS))

### Our Telegram channels:

English: [@TeleSeedCH](https://telegram.me/teleseedch)

Persian: [@IranSeed](https://telegram.me/iranseed)
