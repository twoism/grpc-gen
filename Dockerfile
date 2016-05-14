FROM ubuntu:14.04
WORKDIR /grpc

ENV GENDIR /grpc/generated
ENV BINPATH /usr/local/bin
ENV GOVERSION go1.6.linux-amd64.tar.gz
ENV GOROOT /usr/local/go
ENV GOPATH /go
RUN mkdir -p /go/src
ENV PATH $GOROOT/bin:$GOPATH/bin:/grpc/node_modules/.bin:/go/bin:$PATH
ENV INSTALL wget php5-cli php5-dev php-pear nodejs npm git
ENV GRPC_WORK_DIR grpc-src
RUN mkdir -p $GENDIR/go $GENDIR/php $GENDIR/js

# Install the world
RUN apt-get -y update \
  && apt-get install -yq --force-yes $INSTALL \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install latest Golang
RUN wget -q https://storage.googleapis.com/golang/$GOVERSION \
    && tar -C /usr/local -xzf $GOVERSION && rm $GOVERSION

# gRPC & Protoc
RUN git clone https://github.com/grpc/grpc.git $GRPC_WORK_DIR\
  && cd $GRPC_WORK_DIR && git submodule update --init \
  && make plugins \
  && cp ./bins/opt/grpc_*_plugin $BINPATH \
  && cp ./bins/opt/protobuf/protoc $BINPATH \
  && cd .. && rm -rf $GRPC_WORK_DIR

# # PHP Deps
ADD resources/composer-setup.php .
RUN php composer-setup.php --install-dir=$BINPATH --filename=composer
RUN pear install Console_CommandLine
ADD ./composer.json .
RUN composer -qn install

# # Node Deps
ADD ./package.json .
RUN npm -qy install
RUN ln -s $(which nodejs) /usr/local/bin/node

# Go Deps
ENV GODEPS github.com/golang/protobuf/proto \
  github.com/golang/protobuf/protoc-gen-go \
  golang.org/x/net/context \
  google.golang.org/grpc
RUN go get -u $GODEPS

ADD ./script/generate ./script/generate
ADD ./script/generate-go ./script/generate-go
ADD ./script/generate-js ./script/generate-js
ADD ./script/generate-php ./script/generate-php
