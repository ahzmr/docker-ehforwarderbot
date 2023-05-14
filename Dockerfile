FROM python:3.10-alpine
MAINTAINER Jemy Zhang <jemy.zhang@gmail.com>

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'
ENV EFB_DATA_PATH /data/
ENV EFB_PARAMS ""
ENV EFB_PROFILE "default"
ENV HTTPS_PROXY ""

ENV BUILD_PREFIX=/app

RUN apk add --no-cache tzdata ca-certificates \
       ffmpeg libmagic \
       tiff libwebp freetype lcms2 openjpeg py3-olefile openblas \
       py3-numpy py3-pillow py3-cryptography py3-decorator cairo py3-pip

ADD ./lib ${BUILD_PREFIX}/lib

RUN apk add --no-cache --virtual .build-deps git build-base gcc python3-dev \
    && /usr/local/bin/python -m pip install --no-cache --upgrade pip \
    && pip3 install pysocks ehforwarderbot efb-telegram-master \
    && pip3 install efb-patch-middleware \
    && cd ${BUILD_PREFIX} && pip install ${BUILD_PREFIX}/lib/* \
    && apk del .build-deps

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

ADD entrypoint.sh /entrypoint.sh

WORKDIR ${BUILD_PREFIX}

ENTRYPOINT ["/entrypoint.sh"]
