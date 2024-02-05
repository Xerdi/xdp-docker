ARG FROM=ubuntu:22.04
FROM $FROM

ENV LUA_PATH='/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;./?.lua;./?/init.lua;/home/ltxuser/.luarocks/share/lua/5.3/?.lua;/home/ltxuser/.luarocks/share/lua/5.3/?/init.lua'
ENV LUA_CPATH='/usr/local/lib/lua/5.3/?.so;/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;/usr/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so;/home/ltxuser/.luarocks/lib/lua/5.3/?.so'

# Install Lua & Lua Rocks
RUN apt update -q && \
    apt install -qy lua5.3 liblua5.3-dev lua-yaml luarocks

# Install Lua module lyaml
RUN luarocks install lyaml


