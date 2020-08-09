#!/bin/bash
#
# Script to create an RPM package from the LUA 5.2.X source files.
VERSION=$1
RELEASE=$2

set -e

function usage {
    echo " "
    echo "usage: $0 <version> [release]"
    echo " "
    echo "  e.g. $0 5.2.4"
    echo "  Version must be X.Y with optional .Z"
    echo "  Release must be number, default = 1"
    exit 1
}

# Check validity of version numbers.
if [[ -z "$RELEASE" ]]; then RELEASE=1; fi
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]] || [[ ! $RELEASE =~ ^[0-9]+$ ]]; then
    usage
fi

# Define our base package name. From there we will add some versoning information as required.
N2LUA_PACKAGE="n2lua"
DATE=`date -R`
TAR_N2LUA_PACKAGE=${N2LUA_PACKAGE}_$VERSION.orig.tar.gz

OUR_DIR=`pwd`
BASEPATH=`dirname "$OUR_DIR"`
BASEDIR=`basename "$BASEPATH"`

SRC_DIR=..
DEPLOY_DIR=../deploy

################################################################################
# Clean up.
echo "# Cleaning up"
./clean.sh

################################################################################
# Create the package distribution setup
rm -rf $DEPLOY_DIR
mkdir $DEPLOY_DIR

# Firstly the base service package.
echo "# Building base package directory to $DEPLOY_DIR/$N2LUA_PACKAGE"
cd "$OUR_DIR"
mkdir $DEPLOY_DIR/$N2LUA_PACKAGE

# Create sub directories for all the files that we are deploying.
mkdir $DEPLOY_DIR/$N2LUA_PACKAGE/bin
mkdir $DEPLOY_DIR/$N2LUA_PACKAGE/inc
mkdir $DEPLOY_DIR/$N2LUA_PACKAGE/lib
mkdir $DEPLOY_DIR/$N2LUA_PACKAGE/man

# Compile the LUA source code.
echo "# Compiling: N2LUA LUA Module"
cd "$OUR_DIR/$SRC_DIR/src"
make linux

# Move across the compiled files into the structure that we previously defined.
# Binaries.
cp lua  $DEPLOY_DIR/$N2LUA_PACKAGE/bin
cp luac $DEPLOY_DIR/$N2LUA_PACKAGE/bin

# Include files.
cp lua.h     $DEPLOY_DIR/$N2LUA_PACKAGE/inc
cp luaconf.h $DEPLOY_DIR/$N2LUA_PACKAGE/inc
cp lualib.h  $DEPLOY_DIR/$N2LUA_PACKAGE/inc
cp lauxlib.h $DEPLOY_DIR/$N2LUA_PACKAGE/inc
cp lua.hpp   $DEPLOY_DIR/$N2LUA_PACKAGE/inc

# Lib files.
cp liblua.a $DEPLOY_DIR/$N2LUA_PACKAGE/lib

# Man files.
cp $OUR_DIR/$SRC_DIR/doc/lua.1  $DEPLOY_DIR/$N2LUA_PACKAGE/man
cp $OUR_DIR/$SRC_DIR/doc/luac.1 $DEPLOY_DIR/$N2LUA_PACKAGE/man

# Remove the generated perllocal.pod file to avoid overwriting the destination file.
# TODO: Do we need this?
# echo "# Removing generated perllocal.pod"
cd "$OUR_DIR"
# find $DEPLOY_DIR/$N2LUA_PACKAGE -name perllocal.pod -type f -delete

echo "$VERSION" > $DEPLOY_DIR/$N2LUA_PACKAGE/n2lua-build-version.txt

#
# Finally build our RPM package.
#
VERSION=$VERSION \
RELEASE=$RELEASE \
PACKAGE=$N2LUA_PACKAGE \
    rpmbuild -v \
    --define "_builddir $OUR_DIR/$DEPLOY_DIR/$N2LUA_PACKAGE" \
    --define "_rpmdir %(pwd)/rpms" \
    --define "_srcrpmdir %(pwd)/rpms" \
    --define "_sourcedir %(pwd)/../" \
    -ba n2lua.spec
