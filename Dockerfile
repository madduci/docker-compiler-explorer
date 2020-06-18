FROM madduci/docker-linux-cpp:latest

LABEL maintainer="Michele Adduci <adduci.michele@gmail.com>"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        make \
        git \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && echo "Add Compilers to Compiler-Explorer" \
    && sed -i '/defaultCompiler=/c\defaultCompiler=\/usr\/bin\/g++-8' etc/config/c++.defaults.properties \
    && make webpack

WORKDIR /compiler-explorer

ENTRYPOINT [ "make" ]

CMD ["run"]
