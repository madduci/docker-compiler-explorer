FROM madduci/docker-linux-cpp:latest

LABEL maintainer="Edward Schwartz <edmcman@cmu.edu>" \
      license="Copyright (c) 2012-2021, Matt Godbolt"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        make \
        git \
        wine32 \
        xvfb \
        cabextract \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && echo "Installing MSVC" \
    && wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && (Xvfb :100 &) \
    && export DISPLAY=:100 \
    && WINEARCH=win32 ./winetricks -q vc2005expresssp1 vc2008express \
    && git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && npm run webpack \
    && rm -rf /var/cache/apt/* /tmp/*


RUN cd /root/.wine/drive_c/windows/system32 && ln -s ../../Program\ Files/Microsoft\ Visual\ Studio\ 8/Common7/IDE/mspdb80.dll

ADD cpp.properties /compiler-explorer/etc/config/c++.local.properties
ADD execution.properties /compiler-explorer/etc/config/execution.local.properties

WORKDIR /compiler-explorer

ENTRYPOINT [ "make" ]

CMD ["run"]
