#!/bin/bash

#TODO get a release version if possible
VERSION_swift=
DEPS_swift=(libevent openssl)
#URL_swift=https://nodeload.github.com/triblerteam/libswift/zip/4123e6579309cd65a5ba3800e0b674f348c62bfb
URL_swift=https://nodeload.github.com/libswift/libswift/zip/042f5d51bf36287bbdc56bd80a77b1ce8532b414  #zip/53c17650d1aa4baa2d805e3c388b52d98cd518d5
MD5_swift=
#FILENAME_swift=53c17650d1aa4baa2d805e3c388b52d98cd518d5
#FILENAME_swift=4123e6579309cd65a5ba3800e0b674f348c62bfb
FILENAME_swift=042f5d51bf36287bbdc56bd80a77b1ce8532b414
EXTRACT_swift=$BUILD_PATH/swift/libswift-$FILENAME_swift
BUILD_swift=$BUILD_PATH/swift/swift
RECIPE_swift=$RECIPES_PATH/swift

function prebuild_swift() {
	rm -rf $BUILD_PATH/swift/swift/jni

	if [ -d "$BUILD_libevent/build" ]; then
		mkdir -p $BUILD_PATH/swift/swift/jni
		#ln -s $BUILD_libevent/build $BUILD_PATH/swift/swift/jni/libevent2
		cp -rv $RECIPE_swift/extra/libevent2 $BUILD_PATH/swift/swift/jni/
	else
		false
	fi

	if [ -d "$BUILD_openssl" ]; then
		#ln -s $BUILD_openssl $BUILD_PATH/swift/swift/jni/openssl
		OPENSSL_PATH=$BUILD_PATH/swift/swift/jni/openssl/
		mkdir -p $OPENSSL_PATH/include $OPENSSL_PATH/lib $OPENSSL_PATH/build
		cp -rv $BUILD_openssl/*.a $OPENSSL_PATH/lib/

		# Combine libssl.a and libcrypto.a
		pushd $OPENSSL_PATH/lib/
		ar -x libcrypto.a
		ar -x libssl.a
		ar r libcryptossl.a *.o
		rm *.o
		popd

		#cp -rv $BUILD_openssl/include/openssl/* $OPENSSL_PATH/
		#find $BUILD_openssl -name '*.h' -exec cp {} $OPENSSL_PATH/ \;

		pushd $BUILD_openssl/include/openssl/
		for f in *.h
		do
			#ln -s $(readlink -f $f) .
			cp -v $(readlink $f) $OPENSSL_PATH/
		done
		popd

		true
	else
		false
	fi
}

function build_swift() {
	#if [ ! -d "$BUILD_swift" ]; then
	if [ -d "$BUILD_swift" ]; then
		cd $BUILD_PATH/swift
		mkdir -p swift
		unzip $PACKAGES_PATH/$FILENAME_swift
		#rm -Rf swift/jni
		mv $EXTRACT_swift/* swift/jni/

		# Use differend Android.mk to create a binary instead of a library
		cp $RECIPE_swift/extra/* swift/jni/
	fi
	cd $BUILD_PATH/swift
	ls -lah swift/jni/openssl

	cd $BUILD_swift
	mkdir -p libs

	if [ -f "$BUILD_PATH/libs/swift" ]; then
		#return
		true
	fi

	push_arm

	#FIXME get it so you don't have to download the jni module manually
	export LDFLAGS=$LIBLINK
	try ndk-build -C $BUILD_swift/jni
	unset LDFLAGS

	#TODO find out why it's libevent.so and not libswift.so
	try cp -a $BUILD_swift/libs/$ARCH/libcryptossl $LIBS_PATH/swift
	echo $LIBS_PATH/

	pop_arm
}

function postbuild_swift() {
	true
}

