#!/bin/bash

# version of your package
#VERSION_boost=${VERSION_boost:-1.55.0}

# dependencies of this recipe
DEPS_boost=(python)

# url of the package
URL_boost=http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz

# md5 of the package
MD5_boost=93780777cfbf999a600f62883bd54b17

# default build path
BUILD_boost=$BUILD_PATH/boost/$(get_directory $URL_boost)

# default recipe path
RECIPE_boost=$RECIPES_PATH/boost

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_boost() {
	cd $BUILD_boost

	# Copy android config to boost's user-config.jam
	RECIPECONFIG=${RECIPE_boost}/user-config.jam
	BOOSTCONFIG=${BUILD_boost}/tools/build/v2/user-config.jam

	# Insert android path, arm version and api version into user-config.jam
	try echo "local AndroidNDK = ${ANDROIDNDK} ; " > ${BOOSTCONFIG}
	try echo "local ARMToolchainVersion = 4.8 ; " >> ${BOOSTCONFIG}
	try echo "local AndroidAPIVersion = 14 ; " >> ${BOOSTCONFIG}
	try echo "local PythonInstall = ${BUILD_PATH}/python-install ; " >> ${BOOSTCONFIG}
	try cat ${RECIPECONFIG} >> ${BOOSTCONFIG}

	# Create build tools for boost
	./bootstrap.sh 

	# Apply source code patches for Android
	patch -p1 < ${RECIPE_boost}/patches/boost_1_55_0/boost-1_55_0.patch
}

# function called to build the source code
function build_boost() {
	cd $BUILD_boost
	
	#!!! do not build boost, we just use it as source for libtorrent!!!

	# Build boost with arm architecture
	#push_arm
	#./b2 toolset=gcc-androidR9 link=static 
	#pop_arm
}

# function called after all the compile have been done
function postbuild_boost() {
	true
}
