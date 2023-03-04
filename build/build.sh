#!/bin/bash

set -ex

VERSION=$1
URL=https://alpha.gnu.org/gnu/gnucobol/gnucobol-${VERSION}.tar.xz

FULLNAME=gnucobol-${VERSION}
OUTPUT=$2/${FULLNAME}.tar.xz

REVISION="gnucobol-${VERSION}"
LAST_REVISION="${3}"

echo "ce-build-revision:${REVISION}"
echo "ce-build-output:${OUTPUT}"

if [[ "${REVISION}" == "${LAST_REVISION}" ]]; then
    echo "ce-build-status:SKIPPED"
    exit
fi

STAGING_DIR=$(pwd)/staging
BUILD_DIR=$(pwd)/build
rm -rf ${STAGING_DIR} ${BUILD_DIR}

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
curl -sL ${URL} | tar Jxf - --strip-components=1
# https://stackoverflow.com/questions/37060747/escaping-origin-for-libtool-based-project
./configure LDFLAGS="-Wl,-rpath,'\$\$ORIGIN/../lib'"
make -j$(nproc)
make prefix=${STAGING_DIR} install
popd

export XZ_DEFAULTS="-T 0"
tar Jcf "${OUTPUT}" --transform "s,^./,./gnucobol-${VERSION}/," -C "${STAGING_DIR}" .

echo "ce-build-status:OK"
