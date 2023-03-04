FROM ubuntu:20.04
MAINTAINER Matt Godbolt <matt@godbolt.org>

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y -q && apt upgrade -y -q && apt upgrade -y -q && apt install -y -q \
    bison \
    bzip2 \
    curl \
    file \
    flex \
    gawk \
    gcc \
    git \
    libc6-dev-i386 \
    libelf-dev \
    linux-libc-dev \
    make \
    patch \
    texinfo \
    unzip \
    wget \
    xz-utils

WORKDIR /opt/compiler-explorer/gcc-build
