FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y -q && apt upgrade -y -q
RUN apt install -y -q \
    curl \
    gcc \
    git \
    make \
    patchelf \
    xz-utils \
    libgmp-dev

COPY build /root

WORKDIR /root
