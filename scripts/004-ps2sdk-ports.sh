#!/bin/bash
# ps2sdk-ports.sh by fjtrujy

## Download the source code.
REPO_URL="https://github.com/ps2dev/ps2sdk-ports"
REPO_FOLDER="ps2sdk-ports"

# Checking if a specific TAG has been selected, it is passed using parameter $1
[  -z "$1" ] && REPO_REFERENCE="master" || REPO_REFERENCE=$1
echo "Using repo reference $REPO_REFERENCE"

if test ! -d "$REPO_FOLDER"; then
	git clone $REPO_URL -b ${REPO_REFERENCE} || exit 1
fi
cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${REPO_REFERENCE} && git checkout ${REPO_REFERENCE} || exit 1

## Build and install.
make --quiet || { exit 1; }
