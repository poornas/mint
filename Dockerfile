FROM ubuntu:17.04

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV MAVEN_HOME /opt/maven

COPY . /mint
WORKDIR /mint

RUN apt-get update && apt-get install -y \
  bash \
  curl \
  sudo \
  build-essential \
  curl \
  git \
  python3 \
  python3-pip \
  golang-go \
  jq \ 
  openssl && \
  pip3 install yq && \
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
  sudo apt-get install -y nodejs && \
  sudo apt-get install -y  maven && \
  sudo apt-get install -y default-jre default-jdk && \
  apt-get clean && \ 
  update-alternatives --config java && update-alternatives --config javac && \
  chmod +x ./run.sh

CMD ./run.sh
   