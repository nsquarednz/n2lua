#!/bin/bash
#
# Clean up files created by performing package builds.
#

# Simple helper function to check if there are any instances of a wild card preceeded file type.
# This helps us check if various compiled files when doing our cleanup.
shopt -s nullglob
function have_any () {
    [ $# -gt 0 ]
}

# Clean up any generated build files.
if [ -d ../deploy ]; then
    echo "Removing existing deployment directory."
    rm -rf ../deploy
fi

# Clean up any compiled files from the source directory.

# O files.
if have_any ../src/*.o; then
    echo "Removing existing compiled .o files."
    rm ../src/*.o
fi

# A files.
if have_any ../src/*.a; then
    echo "Removing existing compiled .a files."
    rm ../src/*.a
fi

# Compiled LUA binary.
if [ -f ../src/lua ]; then
    echo "Removing existing compiled lua."
    rm ../src/lua
fi

# Compiled LUAC binary.
if [ -f ../src/luac ]; then
    echo "Removing existing compiled luac."
    rm ../src/luac
fi

# Clean up any remaining artifacts.
if [ -d rpms ]; then
    echo "Removing existing build artifacts."
    rm -r rpms
fi
