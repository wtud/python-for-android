#!/bin/bash

VERSION_twisted=${VERSION_twisted:-11.1}
URL_twisted=http://pypi.python.org/packages/source/T/Twisted/Twisted-13.2.0.tar.bz2
DEPS_twisted=(zope)
MD5_twisted=83fe6c0c911cc1602dbffb036be0ba79
BUILD_twisted=$BUILD_PATH/twisted/$(get_directory $URL_twisted)
RECIPE_twisted=$RECIPES_PATH/twisted

function prebuild_twisted() {
	true
}

function shouldbuild_twisted() {
	if [ -d "$SITEPACKAGES_PATH/twisted" ]; then
		DO_BUILD=0
	fi
}

function build_twisted() {

	cd $BUILD_twisted

	push_arm
	export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
	export LDSHARED="$LIBLINK"

	export PYTHONPATH=$BUILD_hostpython/Lib/site-packages

	# fake try to be able to cythonize generated files
	$HOSTPYTHON setup.py build_ext
	try find . -iname '*.pyx' -exec $CYTHON {} \;
	try $HOSTPYTHON setup.py build_ext -v
	try find build/lib.* -name "*.o" -exec $STRIP {} \;

        try $BUILD_hostpython/hostpython setup.py install -O2 --root=$BUILD_PATH/python-install --install-lib=lib/python2.7/site-packages

	try rm -rf $BUILD_PATH/python-install/lib/python*/site-packages/twisted/test
	try rm -rf $BUILD_PATH/python-install/lib/python*/site-packages/twisted/*/test

	unset LDSHARED

	pop_arm
}

function postbuild_twisted() {
	true
}

