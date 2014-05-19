#!/bin/bash
 
# REPLACE ALL THE "tribler" OF THIS FILE WITH THE MODULE NAME
# THEN REMOVE THIS ERROR AND EXIT
 
# version of your package
VERSION_tribler=${VERSION_tribler:-0.1.0}
 
# dependencies of this recipe
DEPS_tribler=(kivy openssl)
 
# url of the package
URL_tribler=http://ios-dev.no-ip.org/Tribler-$VERSION_tribler.tar.gz
 
# md5 of the package
MD5_tribler=d6458740b494d716fe54cd956b7c7e43
 
# default build path
BUILD_tribler=$BUILD_PATH/tribler/$(get_directory $URL_tribler)
 
# set the correct source and destination for the curves.ec file (this is not automatically done so we have to do it)
# CURVES_source=$BUILD_tribler/tribler/crypto/curves.ec
# CURVES_dest=$BUILD_PATH/python-install/lib/python2.7/site-packages/tribler/crypto/curves.ec
 
 
# default recipe path
RECIPE_tribler=$RECIPES_PATH/tribler
 
# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_tribler() {
	echo "_lsprof.so" >> "${BUILD_PATH}/whitelist.txt"
}
 
# function called to build the source code
function build_tribler() {
	cd $BUILD_tribler
	push_arm
	try $HOSTPYTHON setup.py install
	pop_arm
}
 
# function called after all the compile have been done
function postbuild_tribler() {
 
	# curves.ec probably gets ignored by setup.py install,
	# copy it manually to site-packages of the built python
	# try cp $CURVES_source $CURVES_dest
 
}
