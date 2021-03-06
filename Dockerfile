FROM ubuntu:14.04
MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

# Install basic tools.
RUN apt-get update && apt-get install -y vim gdb cscope make curl tar gzip git build-essential pstack vim-syntax-go

# Install docker client.
RUN apt-get install -y apt-transport-https ca-certificates && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list && \
	apt-get update && apt-get install -y docker-engine

# Install Go.
WORKDIR /usr/local/
RUN mkdir -p /usr/local/gopath
RUN curl https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz | tar xz
ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/gopath

# Install etcd.
RUN curl -L https://github.com/coreos/etcd/releases/download/v3.0.13/etcd-v3.0.13-linux-amd64.tar.gz | tar xz
ENV ETCD_HOME /usr/local/etcd-v3.0.13-linux-amd64

ENV PATH $ETCD_HOME:$GOROOT/bin:$GOPATH/bin:$PATH

WORKDIR /root/

# 
COPY vim/.vim /root/.vim
COPY vim/.vimrc /root/.vimrc
COPY build_cscope_db /usr/local/bin/

CMD ["/bin/bash"]
