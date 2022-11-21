#!/bin/bash

# KAARBS-OpenRC: Kojiros Automated Artix Ricing Bash Script
# ##################################################
# This script is intended to be a quick/lazy way of auto-installing all the packages I normally 
# would but with the option to pick and choose what you want to install. This is mainly for my 
# personal use, however others could use it. Because of my lack of technical knowledge
# it does still require a slight amount of tinkering afterwards, but this should do for now.

# LIST OF FUNCTIONS
# Color coded text.
# No Color
NC='\033[0m'

# Red
RED='\033[0;31m'

#Cyan
CYAN='\033[0;36m'

#Yellow
YELLOW='\033[0;33m'

# Installs dependencies.
install_dep () {
	echo -e "${CYAN}proceeding to install necessary dependencies...${NC}" && sleep 2; 
	sudo pacman -S rsync wget noto-fonts noto-fonts-cjk noto-fonts-emoji terminus-font pacman-contrib arandr ufw ufw-openrc qt5-base qt5-svg qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-multimedia zip unzip unrar p7zip logrotate;
	sudo rc-update add ufw boot;
	sudo ufw enable
}

# Confirmation of script initialization.
script_init () {
        while true
        do
        read -p "Welcome to KAARBS OpenRC Edition (Kojiros Automated Artix Ricing Bash Script)."$'\n'"This script gives you the option to install my preferred packages/configs."$'\n'"Before running this script, please make sure that you've read the README, and that your system is completely up to date."$'\n'"(P)roceed,(E)xit,(L)ist packages or (S)kip ahead if re-running script. [p/e/l/s]:" yn

        case $yn
        in
	[pP] ) echo -e "${CYAN}installing dependencies${NC}";
                  install_dep && break;;
           [eE] ) echo -e "${RED}exiting KAARBS"; exit;;
           [lL] ) clear; echo -e "rsync"$'\n'"noto-fonts"$'\n'"noto-fonts-cjk"$'\n'"noto-fonts-emoji"$'\n'"terminus-font"$'\n'"pacman-contrib"$'\n'"arandr"$'\n'"ufw"$'\n'"qt5-base"$'\n'"qt5-svg"$'\n'"qt5-quickcontrols"$'\n'"qt5-quickcontrols2"$'\n'"qt5-graphicaleffects"$'\n'"qt5-multimedia${NC}"; script_init;;
	   [sS] ) echo -e "${YELLOW}skipping dependencies...${NC}"; break;;
              * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs nvidia settings package.
install_nvidia () {
	sudo pacman -S nvidia-settings
}
	
# Confirmation of nvidia-settings installation.
confirm_nvidia () {
	while true
	do
	read -p "do you have an nvidia gpu? [y/n/s]:" yn
	
	case $yn
	in [yY] ) echo -e "${CYAN}installing nvidia settings${NC}";
		  install_nvidia && break;;
	   [nN] ) echo -e "${YELLOW}skipping nvidia settings...${NC}"; break;;
	   [sS] ) echo -e "${YELLOW}skipping dependency...${NC}"; break;;
	      * ) echo -e "${RED}invalid response${NC}";;
	esac
done
}

# Installs the AUR helper, yay.
install_yay () { 
	git clone https://aur.archlinux.org/yay.git;
 	cd yay;
	makepkg -si
}

# The confirmation prompt for yay.
confirm_yay () {
	while true
	do
	read -p "would you like to install the aur helper, yay? [*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT] [y/n]:" yn

	case $yn
	in [yY] ) echo -e "${CYAN}installing yay${NC}";
		  install_yay && break;;
	   [nN] ) echo -e "${YELLOW}skipping yay...${NC}"; break;;
	      * ) echo -e "${RED}invalid response${NC}";;
	esac
done
}

# Enables flathub repository.
install_flatpak () {
	sudo pacman -S flatpak
}

# Restart the system after enabling flathub repo.
restart_flatpak () {
	sudo reboot
}

# Confirmation for enabling flathub repo.
confirm_flatpak () {
	while true
        do
        read -p "would you like to enable the flathub repository? [*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT] [y/n]:" yn

        case $yn
        in [yY] ) echo -e "${CYAN}enabling flatpaks ${YELLOW}(you will need to reboot after it has completed)${NC}";
                  install_flatpak && break;;
           [nN] ) echo -e "${YELLOW}skipping flatpak repo...${NC}"; break;;
              * ) echo -e "${RED}invalid response${NC}";;
        esac
done
} 

# Confirmation for rebooting to finish enabling flathub repo.
confirm_restart () {
        while true
        do
        read -p "if you enabled the flathub repo, you must reboot your system to install flatpaks."$'\n'"would you like to reboot now? [run this script again after rebooting to continue] [y/n]:" yn

        case $yn
        in [yY] ) echo -e "${CYAN}rebooting...${NC}";
                  restart_flatpak;;
           [nN] ) echo -e "${YELLOW}skipping reboot...${NC}"; break;;
              * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs the awesome window manager (and other packages to fill in the gaps)
install_awesomewm () {
	sudo pacman -S awesome picom xorg-xprop xscreensaver dmenu polkit-gnome kitty unclutter lxappearance pavucontrol pcmanfm scrot sxiv imagemagick conky;
	mkdir ~/.config/awesome/;
	git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git;
	mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome;rm -rf awesome-copycats;
	cp ~/.config/awesome/rc.lua.template ~/.config/awesome/rc.lua;
}

# Confirmation of awesomewm installation.
confirm_awesomewm () {
	while true
	do
	read -p "would you like to install awesomeWM - the dynamic window manager?(Y)es, (N)o, or (L)ist packages [y/n/l]:" yn

        case $yn in
	[yY] ) echo -e "${CYAN}installing awesomeWM + other packages to fill in the gaps.${NC}";
               install_awesomewm && break;;
        [nN] ) echo -e "${YELLOW}skipping awesomeWM...${NC}"; break;;
        [lL] ) clear; echo -e "${CYAN}awesome\nnitrogen\npicom\nxorg-xwininfo\nxorg-xprop\nxscreensaver\ndmenu\npolkit-gnome\nkitty\nunclutter\nlxappearance\npavucontrol\npcmanfm\nscrot\nfeh\nimagemagick\nconky${NC}"; confirm_awesomewm;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}	

# Installs simple desktop display manager + a custom lain theme.
install_sddm () {
     sudo pacman -S sddm;
     sudo rc-update add sddm boot;
     git clone https://aur.archlinux.org/sddm-lain-wired-theme.git;
     cd sddm-lain-wired-theme;
     makepkg -Ccsi;
     cd;
     echo -e "[Theme]"$'\n'"Current=sddm-lain-wired-theme">>sddm.conf;
     sudo mv sddm.conf /etc/sddm.conf
}

# Confirmation of sddm installation.
confirm_sddm () {
while true
	do
	read -p "would you like to install sddm - a login screen manager? [y/n]:" yn

        case $yn in
	[yY] ) echo -e "${CYAN}installing+enabling sddm${NC}";
               install_sddm && break;;
        [nN] ) echo -e "${YELLOW}skipping sddm...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Copies my configs and themes over
install_configs () {
# Clones the repo of my custom configs/wm theme.
    cd ~/;
    git clone https://github.com/basedghost/dotfiles && cd dotfiles;

# Clones the config directory
    rsync -vrP .config/ ~/.config/

# Clones the icons directory
    rsync -vrP .icons/ ~/.icons/
    
# Clones the /usr/ directory
    sudo cp -r usr/ /
    cd /usr/local/bin/
    sudo chmod +x FL;
    sudo chmod +x awesome_display_layout.sh;
    sudo chmod +x graal;
    sudo chmod +x lock.sh;
    sudo chmod +x noisegate;
    sudo chmod +x nrestore.sh;
    sudo chmod +x pwrestart;
    sudo chmod +x screentearfix.sh;
    sudo chmod +x sleep.sh;
    sudo chmod +x webcam;
    cd ~/dotfiles/
    
# Clones the /etc/ directory
    sudo cp -r etc/ /

# Clones the local directory
    rsync -vrP .local/ ~/.local/
    
# Bashrc (preserves a copy of your current bashrc)
    mv ~/.bashrc ~/.bashrc.backup
    mv bashrc ~/.bashrc

# Gnu emacs config
    mv emacs ~/.emacs;
    rsync -vrP Pictures/ ~/Pictures/

# Xscreensaver config
    mv xscreensaver ~/.xscreensaver
    
# Noise gate config file for carla
    mv audio.carxp ~/audio.carxp

# Custom sudo lecture (requires the use of the sudo visudo command to add the lines "Defaults lecture=always" and "Defaults lecture_file=/home/user/lecture")
    mv lecture ~/lecture

# Ffmpeg batch convert script
    chmod +x ffmpeg-batch.sh && mv ffmpeg-batch.sh ~/ffmpeg-batch.sh
    
# Installs figlet
   sudo pacman -S figlet;
 
# Shell color scripts
	yay -S shell-color-scripts;
	colorscript -b 00default.sh;
	colorscript -b alpha;
	colorscript -b arch;
	colorscript -b awk-rgb-test;
	colorscript -b bars;
	colorscript -b blocks1;
	colorscript -b blocks2;
	colorscript -b bloks;
	colorscript -b colorbars;
	colorscript -b colortest;
	colorscript -b colortest-slim;
	colorscript -b colorview;
	colorscript -b colorwheel;
	colorscript -b crowns;
	colorscript -b crunch;
	colorscript -b crunchbang;
	colorscript -b crunchbang-mini;
	colorscript -b darthvader;
	colorscript -b debian;
	colorscript -b dna;
	colorscript -b doom-original;
	colorscript -b doom-outlined;
	colorscript -b faces;
	colorscript -b fade;
	colorscript -b guns;
	colorscript -b hex;
	colorscript -b illumina;
	colorscript -b jangofett;
	colorscript -b kaisen;
	colorscript -b manjaro;
	colorscript -b monster;
	colorscript -b mouseface;
	colorscript -b mouseface2;
	colorscript -b panes;
	colorscript -b print256;
	colorscript -b pukeskull;
	colorscript -b rails;
	colorscript -b rally-x;
	colorscript -b six;
	colorscript -b spectrum;
	colorscript -b square;
	colorscript -b suckless;
	colorscript -b tanks;
	colorscript -b thebat;
	colorscript -b thebat2;
	colorscript -b tiefighter1;
	colorscript -b tiefighter1-no-invo;
	colorscript -b tiefighter1row;
	colorscript -b tiefighter2;
	colorscript -b tux;
	colorscript -b xmonad;
	colorscript -b zwaves
	cd ~/
}

# Confirmation to copy my custom configs/theming.
confirm_configs () {
    while true
        do
        read -p "would you like to install kojiros custom configs/themes? [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing kojiros configs/themes${NC}";
               install_configs && break;;
        [nN] ) echo -e "${YELLOW}skipping kojiros configs...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs oh-my-bash, custom themes for bash shell.
install_omb () {
     sudo pacman -S curl;
     bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
     sudo echo "colorscript random">>.bashrc
     mv dotfiles/.oh-my-bash/custom/aliases/custom.aliases.sh ~/.oh-my-bash/custom/aliases/custom.aliases.sh
}

confirm_omb () {
    while true
        do
        read -p "would you like to install oh-my-bash? (custom bash themes) [this will end kaarbs. you must re-run kaarbs after oh-my-bash is installed to continue.] [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing oh my bash${NC}";
               install_omb && break;;
        [nN] ) echo -e "${YELLOW}skipping oh my bash...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs my personal browser of choice, libreWolf.
install_librewolf () {
	yay -S librewolf-bin
}

# Confirmation prompt for libreWolf.
confirm_librewolf () {
	while true
	do
	read -p "would you like to install the librewolf web browser? [requires yay] [y/n]:" yn

	case $yn in
	[yY] ) echo -e "${CYAN}installing librewolf${NC}";
               install_librewolf && break;;
        [nN] ) echo -e "${YELLOW}skipping librewolf...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs the brave web browser - if you prefer chromium-based browsers.
install_brave () {
	yay -S brave-bin
}

# Confirmation prompt for Brave.
confirm_brave () {
	while true
	do 
	read -p "would you like to install the brave web browser? [requires yay] [y/n]:" yn
 
        case $yn in
	[yY] ) echo -e "${CYAN}installing brave${NC}";
               install_brave && break;;
        [nN] ) echo -e "${YELLOW}skipping brave...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs emacs.
install_emacs () {
	sudo pacman -S emacs;
}

# Confirmation prompt for emacs.
confirm_emacs () {
        while true
        do
        read -p "would you like to install gnu emacs? [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing+enabling emacs${NC}";
               install_emacs && break;;
        [nN] ) echo -e "${YELLOW}skipping emacs...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs krita.
install_krita () {
    flatpak install flathub org.kde.krita
}

# Confirmation for krita.
confirm_krita () {
    while true
    do
	read -p "would you like to install krita? [requires flatpak] [y/n]:" yn

	case $yn in
	    [yY] ) echo -e "${CYAN}installing krita${NC}";
		   install_krita && break;;
	    [nN] ) echo -e "${YELLOW}skipping krita...${NC}"; break;;
	    * ) echo -e "${RED}invalid response${NC}";;
	esac
    done
}

# Installs kdenlive.
install_kdenlive () {
	flatpak install flathub org.kde.kdenlive
}

# Confirmation for kdenlive.
confirm_kdenlive () {
	while true
	do
	read -p "would you like to install kdenlive? [requires flatpak] [y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${CYAN}installing kdenlive${NC}";
		install_kdenlive && break;;
	[nN] ) echo -e "${YELLOW}skipping kdenlive...${NC}"; break;;
	   * ) echo -e "${RED}invalid response${NC}";;
	esac
done
}

# Installs picard.
install_picard () {
	sudo pacman -S picard
}

# Confirmation for picard.
confirm_picard () {
	while true
	do
	read -p "would you like to install picard? (gui for managing audio metadata) [y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${CYAN}installing picard${NC}";
		install_picard && break;;
	[nN] ) echo -e "${YELLOW}skipping picard...${NC}"; break;;
	   * ) echo -e "${RED}invalid response${NC}";;
	   esac
done
}

# Installs keepassxc.
install_keepassxc () {
	sudo pacman -S keepassxc
}

# Confirmation for keepassxc.
confirm_keepassxc () {
	while true
	do
	read -p "would you like to install keepassxc? (password manager) [y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${CYAN}installing keepassxc${NC}";
	       install_keepassxc && break;;
	[nN] ) echo -e "${YELLOW}skipping keepassxc...${NC}"; break;;
	   * ) echo -e "${RED}invalid response${NC}";;
	esac
done
}

# Installs discord client that includes screensharing with audio.
install_discord_screenaudio () {
    flatpak install de.shorsh.discord-screenaudio
}

# Confirmation for discord with screenaudio.
confirm_discord_screenaudio () {
        while true
    do
	read -p "would you like to install a discord client that includes screensharing with audio? (recommended to use an alt discord account) [requires flatpak] [y/n]:" yn

	case $yn in
	    [yY] ) echo -e "${CYAN}installing discord w/ screenaudio${NC}";
		   install_discord_screenaudio && break;;
	    [nN] ) echo -e "${YELLOW}skipping discord w/ screenaudio...${NC}"; break;;
	    * ) echo -e "${RED}invalid response${NC}";;
	esac
    done
}

# Installs ani-cli - the command-line tool to stream/download anime.
install_ani () { 
	sudo pacman -S curl mpv openssl ffmpeg;
	git clone "https://github.com/pystardust/ani-cli.git" && cd ./ani-cli;
	sudo cp ./ani-cli /usr/local/bin;
	cd .. && rm -rf "./ani-cli"
}

# Confirmation for ani-cli.
confirm_ani () {
	while true
        do
        read -p "would you like to install ani-cli? (command line interface for anime streaming+downloading) [y/n]:" yn

        case $yn in
	[yY] ) echo -e "${CYAN}installing ani-cli${NC}";
               install_ani && break;;
        [nN] ) echo -e "${YELLOW}skipping ani-cli...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

#Installs biglybt - a bittorrent protocol client.
install_bigly () {
	yay -S biglybt
}

# Confirmation for biglybt.
confirm_bigly () {
        while true
        do
        read -p "would you like to install biglybt? (a bittorrent client) [requires yay] [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing biglybt${NC}";
               install_bigly && break;;
        [nN] ) echo -e "${YELLOW}skipping bigly...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs the dolphin emulator (gamecube/wii)
install_dolphin () {
	flatpak install flathub org.DolphinEmu.dolphin-emu
}

# Confirmation for the dolphin emulator.
confirm_dolphin () {
	while true
	do
	read -p "would you like to install dolphin? (gamecube+wii emulator) [requires flatpak] [y/n]:" yn

	case $yn in
	[yY] ) echo -e "${CYAN}installing dolphin emulator${NC}";
               install_dolphin && break;;
        [nN] ) echo -e "${YELLOW}skipping dolphin emulator...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs mupen64plus. (n64 emulator - rosalie241 version)
install_mupen () {
	flatpak install flathub com.github.Rosalie241.RMG
}

# Confirmation for mupen64plus.
confirm_mupen () {
        while true
        do
        read -p "would you like to install mupen64plus? (nintendo 64 emulator - gui made by rosalie241) [requires flatpak] [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing mupen64plus${NC}";
               install_mupen && break;;
        [nN] ) echo -e "${YELLOW}skipping mupen64plus...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs rpcs3 (playstation 3 emulator)
install_rpcs3 () {
	yay -S rpcs3-bin
}

# Confirmation for rpcs3.
confirm_rpcs3 () {
        while true
        do
        read -p "would you like to install rpcs3? (playstation 3 emulator) [requires yay] [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing rpcs3${NC}";
               install_rpcs3 && break;;
        [nN] ) echo -e "${YELLOW}skipping rpcs3...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs duckstation (playstation aka psx emulator) [flatpak]
install_duckstation () {
	flatpak install flathub org.duckstation.Duckstation
}

# Confirmation for duckstation.
confirm_duckstation () {
        while true
        do
        read -p "would you like to install duckstation? (playstation emulator) [requires flatpak] [y/n]:" yn

        case $yn in
        [yY] ) echo -e "${CYAN}installing duckstation${NC}";
               install_duckstation && break;;
        [nN] ) echo -e "${YELLOW}skipping duckstation...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# Installs flycast (dreamcast emulator)
install_flycast () {
flatpak install flathub org.flycast.Flycast
}

# Confirmation for flycast.
confirm_flycast () {
        while true
        do
        read -p "would you like to install flycast? (dreamcast emulator) [requires flatpak] [y/n]:" yn
        
	case $yn in
        [yY] ) echo -e "${CYAN}installing flycast${NC}";
               install_flycast && break;;
        [nN] ) echo -e "${YELLOW}skipping flycast...${NC}"; break;;
           * ) echo -e "${RED}invalid response${NC}";;
        esac
done
}

# The end of script (also the option to re-run it in case you missed one)
script_finish () {
	while true
        do
        read -p "thank you for using KAARBS."$'\n'"In case you missed a package, you can re-run the script."$'\n'"[E]xit or [R]e-run the script." yn

        case $yn in
        [eE] ) echo -e "${RED}exiting KAARBS"; exit;;
        [rR] ) clear; echo -e "${CYAN}re-running KAARBS${NC}"; script_init;;
           * ) echo -e "${YELLOW}invalid response${NC}";;
        esac 
done
}

# BEGINNING OF SCRIPT

# Welcome/dependencies
script_init

# Nvidia settings (optional dependency)
confirm_nvidia

# AUR helper (makes for easier installations of packages from the arch user repository)
confirm_yay

# Flatpak support
confirm_flatpak

# Restart to finish enabling flatpak support
confirm_restart

# Awesome window manager
confirm_awesomewm

# Simple desktop display manager + custom theme [yay]
confirm_sddm

# Kojiros custom configs
confirm_configs

# Oh my bash
confirm_omb

# Krita
confirm_krita

# Kdenlive
confirm_kdenlive

# Picard
confirm_picard

# Web browser (firefox fork) [yay]
confirm_librewolf

# Web browser (chromium-based) [yay]
confirm_brave

# Gnu emacs
confirm_emacs

# Keepassxc
confirm_keepassxc

# Discord client that includes screensharing with audio
confirm_discord_screenaudio

# Ani-cli
confirm_ani

# Biglybt [yay]
confirm_bigly

# Dolphin [flatpak]
confirm_dolphin

# Mupen64plus [flatpak]
confirm_mupen

# Rpcs3 [flatpak]
confirm_rpcs3

# Duckstation [flatpak]
confirm_duckstation

# Flycast [flatpak]
confirm_flycast

# End of script, with the option to exit or re-run the script in case you missed a package.
# Thank you for using KAARBS.
script_finish
