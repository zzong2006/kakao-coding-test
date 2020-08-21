# 1. Install MySQL
FROM mysql:latest
MAINTAINER zzong2006@yonsei.ac.kr
RUN apt-get y update

# 2. Install git
RUN apt-get -y install git

# 3. clone repository
RUN git clone https://github.com/zzong2006/kakao-coding-test

