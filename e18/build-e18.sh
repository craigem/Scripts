#!/bin/bash

# Original version of this script based on sample sourced from Enlightenment
# Contributing page: http://enlightenment.org/p.php?p=contribute&l=en

##############
# WARNING
# This script is nasty hack with no error control.
# This script assumes you have installed the build dependencies recommended.
# It also installs and builds everything into /opt/e18
# Best of luck!

set -eu
# Where is the source code?
SRCPATH="/home/craige/git/e18"
# My quick and dirty dev install location
PREFIX="/opt/e18"
CORE=(
	efl
	elementary
	evas_generic_loaders
	emotion_generic_players
	enlightenment
	)
SITE="git.enlightenment.org"
GIT="git://$SITE/core"
OPT="--prefix=$PREFIX"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"

for package in "${CORE[@]}"
do
	# Check the source is already there
	if [ -a $SRCPATH/$package ]
	then
		cd $SRCPATH/$package
		make clean distclean || true
		# Update the repos
		echo "Commencing $package rebase operations master!"
		git pull --rebase
	else
		# No source? Clone it!
		cd $SRCPATH
		echo "Got to clone the $package source sir!"
		git clone $GIT/$package.git
		cd $SRCPATH/$package
	fi
	cd $SRCPATH/$package
	./autogen.sh $OPT
	make
	sudo make install
	cd ../..
	sudo ldconfig
done
