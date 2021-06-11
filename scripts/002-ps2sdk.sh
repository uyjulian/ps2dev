#!/bin/bash
# ps2sdk.sh by Naomi Peori (naomi@peori.ca)
# changed to use Git by Mathias Lafeldt <misfire@debugon.org>

# make sure ps2sdk's makefile does not use it
unset PS2SDKSRC

## Download the source code.
REPO_URL="https://github.com/uyjulian/ps2sdk"
REPO_FOLDER="ps2sdk"

# Checking if a specific TAG has been selected, it is passed using parameter $1
[  -z "$1" ] && REPO_REFERENCE="uyjworking" || REPO_REFERENCE=$1
echo "Using repo reference $REPO_REFERENCE"

if test ! -d "$REPO_FOLDER"; then
	git clone $REPO_URL -b ${REPO_REFERENCE} || exit 1
fi
cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${REPO_REFERENCE} && git checkout ${REPO_REFERENCE} || exit 1

## Determine the maximum number of processes that Make can work with.
#OSVER=$(uname)
#if [ ${OSVER:0:10} == MINGW32_NT ]; then
#	PROC_NR=$NUMBER_OF_PROCESSORS
#elif [ ${OSVER:0:6} == Darwin ]; then
#	PROC_NR=$(sysctl -n hw.ncpu)
#else
#	PROC_NR=$(nproc)
#fi

## Build and install
# Workaround 2018/10/18: remove -j as the ps2toolchain's Makefiles do not have dependencies set up properly.
make --quiet clean && make --quiet && make --quiet install && make --quiet clean || { exit 1; }

## gcc needs to include libps2sdkc, libkernel and libcdvd from ps2sdk to be able to build executables,
## because they are part of the standard libraries 
ln -sf "$PS2SDK/ee/lib/libps2sdkc.a" "$PS2DEV/ee/mips64r5900el-ps2-elf/lib/libps2sdkc.a" || { exit 1; }
ln -sf "$PS2SDK/ee/lib/libkernel.a"  "$PS2DEV/ee/mips64r5900el-ps2-elf/lib/libkernel.a" || { exit 1; }
ln -sf "$PS2SDK/ee/lib/libcdvd.a"  "$PS2DEV/ee/mips64r5900el-ps2-elf/lib/libcdvd.a"  || { exit 1; }
