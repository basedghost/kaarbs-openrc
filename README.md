# kaarbs-openrc
kojiros automated artix ricing bash script

This script is a fork of [kaarbs](https://github.com/basedghost/kaarbs) that was written for Artix Linux with the OpenRC init system.

# Instructions:
1. Clone the repo + move the script to your home folder:
```
git clone https://github.com/basedghost/kaarbs-openrc/ && mv kaarbs/kaarbs-*.sh kaarbs-openrc.sh
```
2. Make the script executable:
```
chmod +x kaarbs-openrc.sh
```
3. Run the script:
```
./kaarbs-openrc.sh
```
(Recommended) If you would like to view the contents of the script before executing it:
```
cat kaarbs-openrc.sh
```

This script has been tested on a fresh [Artix Linux](https://artixlinux.org/download.php) install in QEMU-KVM and on a Thinkpad T500 (using the LXDE Calamares installer)

This script pulls dotfiles from my [personal repository](https://github.com/basedghost/dotfiles/).
There is a [complete list of packages](PACKAGES.md) that this script gives you the choice of installing, if you'd like to check before running it.

## post-script tweaks

Here's a couple of things you might want to do after using kaarbs:
- If you'd like to use the [custom sudo lecture](https://github.com/basedghost/dotfiles/blob/main/lecture), use ```sudo visudo``` and add these two lines: 
```
"Defaults lecture=always"
"Defaults lecture_file=~/lecture"
```
- If you'd like to use animated cursors, use the program lxappearance to choose between them.

## Issues
If any issues with certain packages arise, they will be noted here.
- Picom has recently been leaking both host and gpu memory. It has been temporarily disabled from the script.
