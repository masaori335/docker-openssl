FROM masaori/docker-llvm:3.6

WORKDIR /opt

ENV OPENSSL_VERSION 1.0.2d
ENV OPENSSL_GPG_PUBLIC_KEY_ID 0E604491

# Download openssl
RUN wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" && \
    wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz.asc" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key ${OPENSSL_GPG_PUBLIC_KEY_ID} && \
    gpg --verify openssl-${OPENSSL_VERSION}.tar.gz.asc

RUN apt-get install -y \
    zlib1g \
    zlib1g-dev

# Build openssl
RUN tar xvf openssl-${OPENSSL_VERSION}.tar.gz -C /usr/local/src/ && \
    cd /usr/local/src/openssl-${OPENSSL_VERSION} && \
    ./config shared zlib && \
    make -j$(nproc) && \
    make test && \
    make install

RUN echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl.conf && \
    ldconfig

ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/usr/local/ssl/lib/pkgconfig
ENV PATH $PATH:/usr/local/ssl/bin
