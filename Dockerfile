# 1. Install MySQL
FROM mysql:latest
MAINTAINER zzong2006@yonsei.ac.kr
RUN apt-get -y update

# 2. Install git and nano
RUN apt-get -y install git
RUN apt-get -y install nano

# 4. clone repository
RUN git clone https://github.com/zzong2006/kakao-coding-test /home/kakao-coding-test

# 3. Install JAVA
RUN apt-get -y install wget
RUN wget mirror.xinet.kr/java/jdk-8u191-linux-x64.tar.gz
RUN tar xvfz jdk-8u191-linux-x64.tar.gz 
RUN mv jdk1.8.0_191 /usr/local/java
ENV JAVA_HOME /usr/local/java
ENV PATH $JAVA_HOME/bin:$PATH
RUN cp /home/kakao-coding-test/utils/mysql-connector-java-8.0.21.jar $JAVA_HOME/jre/lib/ext/

# Install Maven
RUN wget http://mirror.apache-kr.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar xvfz apache-maven-3.6.3-bin.tar.gz
RUN mv apache-maven-3.6.3 /usr/local/maven
ENV PATH /usr/local/maven/bin:$PATH

# Install Hadoop (For Minicluster)
RUN apt-get -y install ssh
RUN apt-get -y install pdsh
RUN wget http://apache.mirror.cdnetworks.com/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
RUN tar xvfz hadoop-3.2.1.tar.gz
RUN mv hadoop-3.2.1 /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH


RUN git config --global user.email "zzong2006@gmail.com"
