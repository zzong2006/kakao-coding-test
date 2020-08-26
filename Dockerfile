FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y locales

ENV LANGUAGE ko_KR.UTF-8
ENV LANG ko_KR.UTF-8

