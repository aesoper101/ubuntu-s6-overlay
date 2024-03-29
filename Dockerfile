FROM ubuntu:22.04
MAINTAINER "aesoper" <weilanzhuan@163.com>

ARG S6_OVERLAY_VERSION=3.1.4.1

RUN apt-get update && apt-get install apt-transport-https ca-certificates -y && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo deb https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse  >> /etc/apt/sources.list && \
    echo deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse >> /etc/apt/sources.list


# install openldap \
RUN apt-get update -y && apt-get upgrade -y && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xz-utils \
    dialog \
    apt-utils \
    ca-certificates \
    tree \
    vim && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY rootfs /

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp

#
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    tar -C / -Jxpf /tmp/syslogd-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz


ENTRYPOINT ["/init"]
