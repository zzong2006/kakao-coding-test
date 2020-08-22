# 1. Install MySQL
FROM mysql:latest
MAINTAINER zzong2006@yonsei.ac.kr
RUN apt-get -y update

# 2. Install git and nano
RUN apt-get -y install git
RUN apt-get -y install nano

# 3. Install JAVA
RUN apt-get -y install wget
RUN wget mirror.xinet.kr/java/jdk-8u191-linux-x64.tar.gz
RUN tar xvfz jdk-8u191-linux-x64.tar.gz 
RUN mv jdk1.8.0_191 /usr/local/java

# 4. clone repository
RUN git clone https://github.com/zzong2006/kakao-coding-test /home/kakao-coding-test
RUN git config --global user.email "zzong2006@gmail.com"
