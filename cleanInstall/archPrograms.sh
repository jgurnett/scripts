#!/bin/bash
#------------------------------------------------------------------------------
# Author: 	Joel Gurnett
# Desc: 	Downloads and installs programs when starting fresh on Arch
# Date:		October 17, 2020
#------------------------------------------------------------------------------

# array of programs that are on git
declare -a gitArray=("https://aur.archlinux.org/brave-bin.git" \
	"https://aur.archlinux.org/brave-bin.git" "https://aur.archlinux.org/code-git.git" \
	"https://aur.archlinux.org/etcher-cli-git.git" "https://aur.archlinux.org/teamviewer.git"\
	"https://aur.archlinux.org/gkrellm-git.git" "https://aur.archlinux.org/spotify.git")

# array of programs that will use pacman
declare -a progArray=(vlc htop virtualbox wireguard-tools transmission-qt owncloud-client copyq)

# desc:installs a program with pacman
# usage: instappProgram <program name>
installProgram() {
	echo "installing " $1 "..."
	if sudo pacman -S $1 --noconfirm; then
		echo $1 " installed!"
	else
		echo $1 " Failed! :("
	fi
}

echo "install dev-tools"
sudo pacman -S base-devel --noconfirm

echo "making program directory..."
mkdir programs

cd programs

# Downloads all git repositories from array
echo "pulling programs..."
for val in ${gitArray[@]} ; do
	if git clone $val ; then
		echo $val " Downloaded successfully"
	else
		echo $val " Download Failed"
	fi
done

# builds all git repositories with makepkg
echo "building programs..."
for D in */ ; do
	cd $D
	if makepkg -si --noconfirm; then
		echo "success"
	else
		echo $D " failed"
	fi
	cd ..
done
cd ~
# installs all programs that use pacman
for val in ${progArray[@]}; do
	installProgram $val 
done

echo "Finished!"
