FROM tklx/base:0.1.1
MAINTAINER Michele Adduci <info@micheleadduci.net>

EXPOSE 10240

RUN echo "*** Installing gcc (4.9->7) and clang (3.8->5) ***" \    
    && echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" >> /etc/apt/sources.list.d/unstable.list \
    && apt-get update \
    && apt-get install -y \
         wget \
         ca-certificates \
         nodejs \
         npm \
         g++ \
         make \
         git \
    && apt-get install -t unstable -y g++-4.9 g++-5 g++-6 g++-7 \
    && apt-get install -t unstable -y clang++-3.8 \
    && apt-get install -t unstable -y clang++-3.9 \
    && apt-get install -t unstable -y clang++-4.0 \
    && apt-get install -t unstable -y clang++-5.0 \    
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/*

RUN echo "*** Installing Compiler Explorer ***" \
    && git clone https://github.com/mattgodbolt/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Correct Nodejs command for Docker" \
    && sed -i '/node_modules\/bower\/bin\/bower install/c\\t\/usr\/bin\/nodejs .\/node_modules\/bower\/bin\/bower install --allow-root' /compiler-explorer/Makefile \
    && sed -i 's|--exec $(NODE) $(NODE_ARGS) -- ./app.js --language $(LANG) $(EXTRA_ARGS)||' /compiler-explorer/Makefile \
    && echo "Add Compilers to Compiler-Explorer" \
    && sed -i '/compilers=/c\compilers=\/usr\/bin\/g++-4.9:\/usr\/bin\/g++-5:\/usr\/bin\/g++-6:\/usr\/bin\/g++-7:\/usr\/bin\/clang++-3.8:\/usr\/bin\/clang++-3.9:\/usr\/bin\/clang++-4.0:\/usr\/bin\/clang++-5.0' etc/config/c++.defaults.properties \
    && sed -i '/defaultCompiler=/c\defaultCompiler=\/usr\/bin\/g++-7' etc/config/c++.defaults.properties \
    && make
    
WORKDIR /compiler-explorer

ENTRYPOINT [ "/usr/bin/nodejs app.js" ]