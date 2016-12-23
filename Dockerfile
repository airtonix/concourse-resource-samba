FROM alpine:latest

MAINTAINER Zeno Jiricek <airtonix@gmail.com>

RUN mkdir /mnt/storage
ADD ./resource /opt/resource
RUN chmod +x /opt/resource/*
