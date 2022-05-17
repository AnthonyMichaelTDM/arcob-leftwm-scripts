#!/bin/bash
#set -e
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################

###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################


func_install() {
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
  		echo "###############################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "###############################################################################"
      	echo
		tput sgr0
	else
    	tput setaf 3
    	echo "###############################################################################"
    	echo "##################  Installing package "  $1
    	echo "###############################################################################"
    	echo
    	tput sgr0
    	sudo pacman -S --noconfirm --needed $1 
    fi
}

###############################################################################
tput setaf 3; echo "Installation of fun terminal scripts and related things";tput sgr0
###############################################################################

tput setaf 3
read -p "Do you wish to proceed?" -n 1 -r proceedYN
tput sgr0
echo
case $cursorYN in
	y | Y) ##proceed
        ;;
	*) ##exit
        exit 0
        ;;
esac

list=(
asciiquarium
bashtop
bash-pipes
boxes
cava
cmatrix
cowfortune
cpufetch-git
curseradio-git
figlet
gotop-bin
lolcat
ranger
sl
slurm
toilet
tty-clock
ufetch
ufetch-arco
wttr
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
    echo $name >> installed-packages.txt
done