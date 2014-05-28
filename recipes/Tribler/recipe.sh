#!/bin/bash
 
# REPLACE ALL THE "Tribler" OF THIS FILE WITH THE MODULE NAME
# THEN REMOVE THIS ERROR AND EXIT
 
# version of your package
VERSION_Tribler=${VERSION_Tribler:-0.1.0}
 
# dependencies of this recipe
DEPS_Tribler=(kivy openssl pycrypto m2crypto sqlite3 pyasn1 netifaces apsw swift twisted)
 
# url of the package
URL_Tribler=http://fr.dosoftware.nl/tsap/Tribler-${VERSION_Tribler}.tar.gz
 
# md5 of the package
MD5_Tribler=dcecd242f826728ca6056a5c9c94024c
 
# default build path
BUILD_Tribler=$BUILD_PATH/Tribler/$(get_directory $URL_Tribler)
 
# set the correct source and destination for the curves.ec file (this is not automatically done so we have to do it)
CURVES_source=$BUILD_Tribler/Tribler/community/privatesemantic/crypto/curves.ec
CURVES_dest=$BUILD_PATH/python-install/lib/python2.7/site-packages/Tribler/community/privatesemantic/crypto/curves.ec
 
 
# default recipe path
RECIPE_Tribler=$RECIPES_PATH/Tribler
 
# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_Tribler() {
	echo "_lsprof.so" >> "${BUILD_PATH}/whitelist.txt"
	echo "_csv.so" >> "${BUILD_PATH}/whitelist.txt"
}
 
# function called to build the source code
function build_Tribler() {
	cd $BUILD_Tribler
	push_arm
	try $HOSTPYTHON setup.py install
	pop_arm
}
 
# function called after all the compile have been done
function postbuild_Tribler() {
 
	# curves.ec probably gets ignored by setup.py install,
	# copy it manually to site-packages of the built python
	try cp $CURVES_source $CURVES_dest
	true 
}
