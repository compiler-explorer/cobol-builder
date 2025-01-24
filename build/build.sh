#!/bin/bash

set -ex

VERSION=$1
TAR_EXTRACT=J
WITH_OR_WITHOUT_CURSES=--without-curses
if [[ "${VERSION}" == "1.1" ]]; then
   TAR_EXTRACT=z
   URL=https://ftp.gnu.org/gnu/gnucobol/gnu-cobol-${VERSION}.tar.gz
   WITH_OR_WITHOUT_CURSES=--with-curses
elif [[ "${VERSION}" =~ "rc" ]] || [[ "${VERSION}" =~ "beta" ]]; then
   URL=https://alpha.gnu.org/gnu/gnucobol/gnucobol-${VERSION}.tar.xz
else
   URL=https://ftp.gnu.org/gnu/gnucobol/gnucobol-${VERSION}.tar.xz
fi

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
curl -sL ${URL} | tar ${TAR_EXTRACT}xf - --strip-components=1
# https://stackoverflow.com/questions/37060747/escaping-origin-for-libtool-based-project
./configure LDFLAGS="-Wl,-rpath,'\$\$ORIGIN/../lib'" --with-math=gmp --without-db ${WITH_OR_WITHOUT_CURSES} --without-xml2 --without-json
make -j$(nproc)
make prefix=${STAGING_DIR} install

# Copy dependent libraries, but not libdl, libc or libpthread. This isn't ideal..
cp $(ldd "${STAGING_DIR}"/bin/* | grep -E  '=> (/usr/)?/lib' | grep -Ev 'lib(pthread|c|dl).so' | awk '{print $3}') ${STAGING_DIR}/lib/
patchelf --set-rpath '$ORIGIN/../lib' $(find ${STAGING_DIR}/lib/ -name \*.so\*)
popd

export XZ_DEFAULTS="-T 0"
tar Jcf "${OUTPUT}" --transform "s,^./,./gnucobol-${VERSION}/," -C "${STAGING_DIR}" .

echo "ce-build-status:OK"
