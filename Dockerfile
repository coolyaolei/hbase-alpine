FROM alpine:latest
MAINTAINER coolyaolei<coolyaolei@sina.com>

ARG HBASE_VERSION=1.3.1

ENV PATH $PATH:/hbase/bin

ENV JAVA_HOME=/usr

LABEL Description="HBase Dev", \
      "HBase Version"="$HBASE_VERSION"

WORKDIR /

# bash => entrypoint.sh
# java => hbase engine
RUN set -euxo pipefail && \
    apk add --no-cache bash openjdk8-jre-base

RUN set -euxo pipefail && \
    apk add --no-cache wget tar && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/hbase//hbase-1.3.1-bin.tar.gz" || \
    mkdir "hbase-$HBASE_VERSION" && \
    tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "hbase-$HBASE_VERSION" --strip 1 && \
    test -d "hbase-$HBASE_VERSION" && \
    ln -sv "hbase-$HBASE_VERSION" hbase && \
    rm -fv "hbase-$HBASE_VERSION-bin.tar.gz" && \
    { rm -rf hbase/{docs,src}; : ; } && \
    apk del tar wget

COPY entrypoint.sh /
COPY conf/hbase-site.xml /hbase/conf/
COPY profile.d/java.sh /etc/profile.d/

# Stargate  8080  / 8085
# Thrift    9090  / 9095
# HMaster   16000 / 16010
# RS        16201 / 16301
EXPOSE 2181 8080 8085 9090 9095 16000 16010 16201 16301

CMD "/entrypoint.sh"
