FROM alpine:latest

MAINTAINER Zeno Jiricek <airtonix@gmail.com>

RUN apk update && \
	apk add \
		bash \
		jq \
		samba-client


RUN mkdir /mnt/storage

COPY ./resource/* /opt/resource/
RUN chmod +x /opt/resource/*
