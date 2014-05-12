#!/bin/bash

# version of your package
VERSION_libtorrent=${VERSION_libtorrent:-0.16.16}

# dependencies of this recipe
DEPS_libtorrent=(boost)

# url of the package
URL_libtorrent=http://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-$VERSION_libtorrent.tar.gz

# md5 of the package
MD5_libtorrent=6895a4d355e6c4a91f35efe746a7511e

# default build path
BUILD_libtorrent=$BUILD_PATH/libtorrent/$(get_directory $URL_libtorrent)

# default recipe path
RECIPE_libtorrent=$RECIPES_PATH/libtorrent

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtorrent() {
	patch $BUILD_libtorrent/include/libtorrent/config.hpp < ${RECIPE_libtorrent}/config.patch
	patch $BUILD_libtorrent/src/file.cpp < ${RECIPE_libtorrent}/file.patch
	patch $BUILD_libtorrent/src/utp_stream.cpp < ${RECIPE_libtorrent}/utp_stream.patch
}

# function called to build the source code
function build_libtorrent() {
	
	# Build using bjam with boost statically linked
	cd $BUILD_libtorrent
	export BOOST_ROOT=$BUILD_boost
	export BOOST_BUILD_PATH=$BUILD_boost/tools/build/v2
	#./configure --enable-python-binding --host=arm-linux-gnueabi --with-boost-system=/home/rolf/Projects/Android/android-libtorrent/Boost-for-Android/build/lib/libboost_system-gcc-mt-1_55.a

	$BUILD_boost/bjam gcc-androidR9 release dht-support=on boost=source link=static geoip=static boost-link=static optimization=space asserts=off 

}

# function called after all the compile have been done
function postbuild_libtorrent() {
	true
}
