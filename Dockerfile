ARG tag=basic
FROM maclotsen/texlive:$tag

ENV LUA_PATH='/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;./?.lua;./?/init.lua;/home/ltxuser/.luarocks/share/lua/5.3/?.lua;/home/ltxuser/.luarocks/share/lua/5.3/?/init.lua'
ENV LUA_CPATH='/usr/local/lib/lua/5.3/?.so;/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;/usr/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so;/home/ltxuser/.luarocks/lib/lua/5.3/?.so'

# Install Git, Lua and module lyaml dependencies
RUN apt install git \
        lua5.3 liblua5.3-dev \
        luarocks lua-yaml

# Install Lua module lyaml
RUN luarocks install lyaml

# Install LaTeX packages
RUN tlmgr install gitinfo-lua lua-placeholders regulatory

# TODO: install XDP from source

# Create User
RUN useradd -ms /bin/bash ltxuser
WORKDIR /home/ltxuser

# Set permissions
RUN chmod a+rx -R .; \
    mkdir -p texmf .texlive2023/texmf-var; \
    chmod a+rwx -R .texlive2023/texmf-var;

# Initialize TeX Live
RUN tlmgr init-usertree; \
    texhash /home/ltxuser/texmf

# Run as the ltxuser for compilation
USER ltxuser

# Load the font db
RUN luaotfload-tool --update;

# Add an optional TDS as mount
VOLUME /home/ltxuser/texmf

# Add the build directory for compilation
RUN git config --global --add safe.directory /build
WORKDIR /build

