#!/bin/bash

# REPLACE ALL THE "anontunnel" OF THIS FILE WITH THE MODULE NAME
# THEN REMOVE THIS ERROR AND EXIT

# version of your package
VERSION_anontunnel=${VERSION_anontunnel:-0.1.0}

# dependencies of this recipe
DEPS_anontunnel=(kivy)

# url of the package
URL_anontunnel=http://ios-dev.no-ip.org/anontunnel-$VERSION_anontunnel.tar.gz

# md5 of the package
MD5_anontunnel=09c4bb84054155f0291d160ec4c0e228

# default build path
BUILD_anontunnel=$BUILD_PATH/anontunnel/$(get_directory $URL_anontunnel)

# default recipe path
RECIPE_anontunnel=$RECIPES_PATH/anontunnel

# set the correct source and destination for the curves.ec file (this is not automatically done so we have to do it)
LOGGER_source=$BUILD_anontunnel/anontunnel/logger.conf
LOGGER_dest=$BUILD_PATH/python-install/lib/python2.7/site-packages/anontunnel/logger.conf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_anontunnel() {
	true
}

# function called to build the source code
function build_anontunnel() {
	cd $BUILD_anontunnel
	push_arm
	try $HOSTPYTHON setup.py install
	pop_arm
}

# function called after all the compile have been done
function postbuild_anontunnel() {
	# logger.conf probably gets ignored by setup.py install,
	# copy it manually to site-packages of the built python
	try cp $LOGGER_source $LOGGER_dest
}
