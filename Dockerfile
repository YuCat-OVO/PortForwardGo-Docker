# syntax=docker/dockerfile:1
FROM docker.io/library/alpine:edge as download

COPY scripts /scripts

ARG VERSION=1.2.0
ARG ARCH=amd64

RUN \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.lzu.edu.cn/g' "/etc/apk/repositories" && \
    apk --no-cache add wget bash && \
    /scripts/download.sh --version ${VERSION} --arch ${ARCH}

FROM docker.io/library/alpine:edge

COPY --from=download /app /app

ENTRYPOINT [ "/app/start.sh" ]