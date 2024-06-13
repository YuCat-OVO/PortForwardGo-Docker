# syntax=docker/dockerfile:1
FROM docker.io/library/alpine:edge as download

COPY scripts /scripts

ARG VERSION=1.2.0
ARG ARCH=amd64

RUN \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.lzu.edu.cn/g' "/etc/apk/repositories" && \
    apk --no-cache add wget bash && \
    /scripts/download.sh --version ${VERSION} --arch ${ARCH}

FROM docker.io/library/alpine:20240606

LABEL org.opencontainers.image.source="https://github.com/YuCat-OVO/PortForwardGo-Docker"

COPY --from=download /app /app

RUN \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.lzu.edu.cn/g' "/etc/apk/repositories" && \
    apk --no-cache add tzdata tini

ENTRYPOINT ["tini", "--", "/app/start.sh" ]