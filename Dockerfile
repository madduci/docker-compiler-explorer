FROM madduci/docker-linux-cpp:latest

LABEL maintainer="Michele Adduci <adduci.michele@gmail.com>"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        npm \
        make \
        git \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone https://github.com/mattgodbolt/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && echo "Add Compilers to Compiler-Explorer" \
    && sed -i '/compilers=/c\compilers=\/usr\/bin\/g++-4.9:\/usr\/bin\/g++-5:\/usr\/bin\/g++-6:\/usr\/bin\/g++-7:\/usr\/bin\/g++-8' etc/config/c++.defaults.properties \
    && sed -i '/defaultCompiler=/c\defaultCompiler=\/usr\/bin\/g++-8' etc/config/c++.defaults.properties \
    && make

WORKDIR /compiler-explorer

ENTRYPOINT [ "/usr/bin/nodejs", "/compiler-explorer/app.js" ]