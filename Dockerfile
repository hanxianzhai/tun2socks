FROM alpine:latest as builder

WORKDIR /src

RUN apk add --update --no-cache wget unzip \
    && wget https://github.com/xjasonlyu/tun2socks/releases/download/v2.5.1/tun2socks-linux-amd64.zip \
    && unzip tun2socks-linux-amd64.zip \
    && mv tun2socks-linux-amd64 tun2socks
    
FROM alpine:latest

COPY ./entrypoint.sh /entrypoint.sh
COPY --from=builder /src/tun2socks /usr/bin/tun2socks

RUN apk add --update --no-cache iptables iproute2 tzdata \
    && chmod +x /entrypoint.sh

ENV TUN=tun0
ENV ADDR=198.18.0.1/15
ENV LOGLEVEL=info
ENV PROXY=direct://
ENV MTU=1280
ENV RESTAPI=
ENV UDP_TIMEOUT=
ENV TCP_SNDBUF=
ENV TCP_RCVBUF=
ENV TCP_AUTO_TUNING=
ENV EXTRA_COMMANDS=
ENV TUN_INCLUDED_ROUTES=
ENV TUN_EXCLUDED_ROUTES=
ENV INTERFACE=tun0

ENTRYPOINT ["/entrypoint.sh"]
