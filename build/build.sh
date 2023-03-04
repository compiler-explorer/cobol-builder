#!/bin/bash

set -ex

VERSION=$1
URL=https://sourceforge.net/projects/gnucobol/files/gnucobol/${VERSION}/gnucobol-${VERSION}-rc2.tar.bz2

FULLNAME=gnucobol-${VERSION}
OUTPUT=$2/${FULLNAME}.tar.xz

REVISION="cobol-${VERSION}"
LAST_REVISION="${3}"

echo "ce-build-revision:${REVISION}"
echo "ce-build-output:${OUTPUT}"

if [[ "${REVISION}" == "${LAST_REVISION}" ]]; then
    echo "ce-build-status:SKIPPED"
    exit
fi

STAGING_DIR=$(pwd)/staging
mkdir -p "${STAGING_DIR}"

cd "${STAGING_DIR}"
curl -sL ${URL} | tar --strip-components=1 Jxf -

./autogen.sh
./configure
make -j$(nproc)
make DESTDIR=${STAGING_DIR} prefix=${STAGING_DIR} install

export XZ_DEFAULTS="-T 0"
tar Jcf "${OUTPUT}" --transform "s,^./,./cobol-${VERSION}/," -C "${STAGING_DIR}" .

echo "ce-build-status:OK"
