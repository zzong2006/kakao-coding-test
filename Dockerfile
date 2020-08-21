# 1. Install MySQL
FROM mysql:latest
MAINTAINER zzong2006@yonsei.ac.kr
RUN apt-get -y update

# 2. Install git and nano
RUN apt-get -y install git
RUN apt-get -y install nano

# 3. clone repository
RUN cd home
RUN git clone https://github.com/zzong2006/kakao-coding-test
RUN git config --global user.email "zzong2006@gmail.com"
