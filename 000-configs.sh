#!/bin/sh

THIS_SCRIPT_PATH="~/arcob-leftwm-scripts/000-configs.sh"
readonly THIS_SCRIPT_PATH

#goto home directory
cd ~/

#clone my configs from my github repository
git clone https://github.com/AnthonyMichaelTDM/my-crispy-arcolinux-configs.git

#variables, storing file paths
CONFIG_DIRECTORY="~/my-crispy-arcolinux-configs/" #for end user: change this to be the directory you stored my configs in
readonly CONFIG_DIRECTORY

LEFTWM_TARGET="~/.config/leftwm/"
readonly LEFTWM_TARGET

ZSHRC_PERSONAL_SOURCE="${CONFIG_DIRECTORY}Scripts/clean/.zshrc-personal"
ZSHRC_PERSONAL_TARGET="~/"
readonly ZSHRC_PERSONAL_SOURCE
readonly ZSHRC_PERSONAL_TARGET

CURSOR_SOURCE="${CONFIG_DIRECTORY}Cursors/BloodMoon-Cursor/"
CURSOR_TARGET="~/.icons"
CURSOR_ROOT_TARGET="/usr/share/icons/"
readonly CURSOR_SOURCE
readonly CURSOR_TARGET
readonly CURSOR_ROOT_TARGET

GTK_SOURCE="${CONFIG_DIRECTORY}GTK/BloodMoon/"
GTK_TARGET="~/.themes"
GTK_ROOT_TARGET="/usr/share/themes/"
readonly GTK_SOURCE
readonly GTK_TARGET
readonly GTK_ROOT_TARGET

VIMRC_SOURCE="${CONFIG_DIRECTORY}vimrc"
VIMRC_TARGET="/etc/"
readonly VIMRC_SOURCE
readonly VIMRC_TARGET

SDDM_SOURCE="${CONFIG_DIRECTORY}SDDM/BloodMoon-sugar-candy/"
SDDM_TARGET="/usr/share/sddm/themes/"
SDDM_CONF="/etc/sddm.conf"
readonly SDDM_SOURCE
readonly SDDM_TARGET
readonly SDDM_CONF

GTK3_SETTINGS="~/.config/gtk-3.0/settings.ini"
readonly GTK3_SETTINGS

ST_SOURCE="${CONFIG_DIRECTORY}arco-st/"
ST_TARGET="~/.config/"
ST_MAKE_DIR="~/.config/arco-st/"
readonly ST_SOURCE
readonly ST_TARGET
readonly ST_MAKE_DIR

SCRIPTS_SOURCE="${CONFIG_DIRECTORY}/Scripts/"
SCRIPTS_TARGET="~/.bin/my-scripts/"    
readonly SCRIPT_SOURCE
readonly SCRIPT_TARGET


echo "################################################################## "
echo "this script will install all my personal configs for a minimal(ish)"
echo "ArcolinuxB installation, it is intended to be run only once"
echo "after the first boot into the system"
echo "- copy vimrc"
echo "- copy sddm theme"
echo "- set sddm theme to copied theme"
echo "################################################################## "
read -r -p "Press Enter to continue"

# phase 1 copy over and install some non-optional things the other things
echo "################################################################## "
echo "Phase 1 : non-optional stuff"
echo "- install my leftwm theme"
echo "- copy .zshrc-personal"
echo "- copy vimrc"
echo "- copy sddm theme"
echo "- set sddm theme to copied theme"
echo "- install and make st"
echo "- install gtk theme to root user"
echo "################################################################## "
##leftwm theme
echo "installing my leftwm theme"
### install leftwm-theme if it isn't already
if ! [[ -x "$(command -v leftwm-theme)" ]]; then 
    echo "    installing leftwm-theme"
    pamac install leftwm-theme
fi
### add theme to themes.toml
#### add repo
echo "    adding theme to themes.toml"
printf "
[[repos]]
url = \"https://raw.githubusercontent.com/AnthonyMichaelTDM/leftwm-personal-themes/main/known.toml\"
name = \"Personal\"
themes = []
" >> ${LEFTWM_TARGET}themes.toml
#### update themes.toml
leftwm-theme update
### install dependencies
echo "    installing dependencies"
if ! [[ -x "$(command -v wal)" ]]; then
    echo "    installing pywal"
    pamac install python-pywal
fi
if ! [[ -x "$(command -v picom)" ]]; then
    echo "    installing picom"
    pamac install picom
fi
if ! [[ -x "$(command -v polybar)" ]]; then
    echo "    installing polybar"
    pamac install polybar
fi
### install theme
echo "    installing theme"
leftwm-theme install "master-pywal-theme"
### apply theme
echo "    apply theme"
leftwm-theme apply "master-pywal-theme"
### override config.toml with themes config.toml
echo "    override config.toml"
cp "${LEFTWM_TARGET}themes/current/config.toml" ${LEFTWM_TARGET}
### modify .zshrc-personal
echo "    modify .zshrc-personal so terminals open with correct colors"
sed -i '1i\ ' $ZSHRC_PERSONAL_SOURCE
sed -i '1i\(cat $HOME/.cache/wal/sequences &)' $ZSHRC_PERSONAL_SOURCE
sed -i '1i\# makes new terminals open with pywal colors' $ZSHRC_PERSONAL_SOURCE
echo "done"
echo

##zshrc-personal
echo "copying zshrc-personal"
sudo cp -f $ZSHRC_PERSONAL_SOURCE $ZSHRC_PERSONAL_TARGET
echo "done"
echo

##vimrc
echo "copying vimrc"
sudo cp -f $VIMRC_SOURCE $VIMRC_TARGET
echo "done"
echo

##sddm
echo "copying sddm theme"
sudo cp -rf $SDDM_SOURCE $SDDM_TARGET
echo "done"
echo "setting SDDM theme to copied theme"
###replace the lines that set current sddm config with my sddm config
sudo sed -i 's/Current=/ # Current=/' $SDDM_CONF
echo "done"
echo

##st
echo "install and make st"
sudo cp -rf $ST_SOURCE $ST_TARGET
sudo make clean install -C $ST_MAKE_DIR
echo "done"
echo

echo "setting GTK theme to my custom theme"
###set gtk 
sudo sed -i 's/gtk-theme-name=/gtk-theme-name=BloodMoon\n# /' $GTK3_SETTINGS
echo "done"
echo

## install root user
echo "copying gtk themes to /usr/share directory"
###copy gtk themes to the root user
sudo cp -rf $GTK_SOURCE $GTK_ROOT_TARGET
echo "done"
echo

# phase 2
echo "################################################################## "
echo "Phase 2 : optional stuff"
echo "- cursor theme"
echo "- brightness scipt"
echo "     - copy brightness script to bin"
echo "     - create sudoers exeption for script"
echo "     - add alias for brightness script to .zshrc-personal"
echo "     - modify sxhkdrc to use brightness script rather than xbacklight"
echo "################################################################## "

read -p "do you want to install the cursor theme? y/n" -n 1 -r cursorYN
echo
case $cursorYN in
	y | Y) 
        ###copy cursor themes to the root user
        sudo cp -rf $CURSOR_SOURCE $CURSOR_ROOT_TARGET
        ###set cursor
        sudo sed -i 's/gtk-cursor-theme-name=/gtk-cursor-theme-name=BloodMoon-Cursor\n# /' $GTK3_SETTINGS
        ###cursor for sddm
        sudo sed -i 's/CursorTheme=/CursorTheme=BloodMoon-Cursor\nCurrent=BloodMoon-sugar-candy\n# /' $SDDM_CONF
        ;;
	*) ##do not install
		;;
esac

read -p "do your brightness keys work as intended? y/n" -n 1 -r brightnessYN
echo
case $brightnessYN in
	n | N) ##modify sxhkdrc of leftwm-theme and .zshrc-personal, also copy the brightness changing script, and make it so that said script can run without needing a sudo password
        
        ###copy brighness changing script
        cd ~/.bin/
        mkdir my-scripts
        cd ~/
        cp -f "${SCRIPT_SOURCE}configure-brightness.sh" "${SCRIPT_TARGET}"
        cp -f "${SCRIPT_SOURCE}configure-brightness-README.md" "${SCRIPT_TARGET}"

        ###create sudoers exeption for brightness changing script
        echo "${USER} ALL=(ALL) NOPASSWD:${SCRIPT_TARGET}configure-brightness.sh" >> /etc/sudoers.d/brightness

        ###modify .zshrc-personal
        ####add references to brightness script
        printf "
        #brightness alias
        alias brightness=\"sudo -n ${SCRIPT_TARGET}configure-brightness.sh\"

        " >> ~/.zshrc-personal
        ###modify sxhkdrc
        sed -i 's/xbacklight/sudo -n ${SCRIPT_TARGET}configure-brightness.sh/g' "${LEFTWM_TARGET}themes/current/sxhkd/sxhkdrc"

        echo "done"
        ;;
	*) ##do not install
		;;
esac

#clean up after yourself
echo "################################################################## "
echo "Phase 3 : clean up"
echo "- remove leftover folders and files, including this script"
echo "################################################################## "
## remove the clone of the configs repo
rm -rf $CONFIG_DIRECTORY
echo "done"

#exit script with success message
echo "restart your computer now"
exit 0
