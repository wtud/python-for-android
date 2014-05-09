#!/bin/bash
 
# REPLACE ALL THE "tribler_core_minimal" OF THIS FILE WITH THE MODULE NAME
# THEN REMOVE THIS ERROR AND EXIT
 
# version of your package
VERSION_tribler_core_minimal=${VERSION_tribler_core_minimal:-0.1.0}
 
# dependencies of this recipe
DEPS_tribler_core_minimal=(kivy openssl)
 
# url of the package
URL_tribler_core_minimal=http://ios-dev.no-ip.org/tribler_core_minimal-$VERSION_tribler_core_minimal.tar.gz
 
# md5 of the package
MD5_tribler_core_minimal=956c50875c28df0fe31061daa825aec8
 
# default build path
BUILD_tribler_core_minimal=$BUILD_PATH/tribler_core_minimal/$(get_directory $URL_tribler_core_minimal)
 
# set the correct source and destination for the curves.ec file (this is not automatically done so we have to do it)
CURVES_source=$BUILD_tribler_core_minimal/tribler_core_minimal/crypto/curves.ec
CURVES_dest=$BUILD_PATH/python-install/lib/python2.7/site-packages/tribler_core_minimal/crypto/curves.ec
 
 
# default recipe path
RECIPE_tribler_core_minimal=$RECIPES_PATH/tribler_core_minimal
 
# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_tribler_core_minimal() {
	echo "_lsprof.so" >> "${BUILD_PATH}/whitelist.txt"
}
 
# function called to build the source code
function build_tribler_core_minimal() {
	cd $BUILD_tribler_core_minimal
	push_arm
	try $HOSTPYTHON setup.py install
	pop_arm
}
 
# function called after all the compile have been done
function postbuild_tribler_core_minimal() {
 
	# curves.ec probably gets ignored by setup.py install,
	# copy it manually to site-packages of the built python
	try cp $CURVES_source $CURVES_dest
 
}
