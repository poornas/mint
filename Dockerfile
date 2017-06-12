FROM ubuntu:17.04

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

COPY . /mint
WORKDIR /mint

RUN apt-get update && apt-get install -y \
  bash \
  build-essential \
  curl \
  git \
  python3 \
  python3-pip \
  golang-go \
  jq \ 
  openssl

RUN go get -u github.com/minio/minio-go && \
go get -u github.com/minio/minio/pkg/madmin &&\
pip3 install yq && \
chmod +x ./run.sh 

CMD ./run.sh
   