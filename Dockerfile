FROM madduci/docker-linux-cpp:latest

LABEL maintainer="Michele Adduci <adduci@tutanota.com>" \
      license="Copyright (c) 2012-2024, Matt Godbolt"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && add-apt-repository -y "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" \
    && add-apt-repository -y "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main" \
    && add-apt-repository -y "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        make \
        git \
        g++-9 \
        g++-10 \
        g++-11 \
        clang-16 \
        clang-17 \
        clang-18 \
        clang-19 \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && make prebuild

ADD cpp.properties /compiler-explorer/etc/config/c++.local.properties

WORKDIR /compiler-explorer

ENTRYPOINT [ "make" ]

CMD ["run-only"]
