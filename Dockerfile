FROM mhart/alpine-node:7
MAINTAINER Zeno Jiricek <airtonix@gmail.com>

RUN mkdir /mnt/storage
ADD ./resource/in /opt/resource/in
ADD ./resource/out /opt/resource/out
ADD ./resource/check /opt/resource/check
ADD ./resource/package.json /opt/resource/package.json
ADD ./resource/lib/* /opt/resource/lib
RUN chmod +x /opt/resource/*
