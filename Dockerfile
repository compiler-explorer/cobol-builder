FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y -q && apt upgrade -y -q
RUN apt install -y -q \
    autoconf \
    bzip2 \
    curl \
    gcc \
    git \
    libdb5.3-dev \
    libgmp-dev \
    make \
    xz-utils

COPY build /build

WORKDIR /build
