ARG tag=slim
FROM maclotsen/xdp-base:$tag
USER root

# Install package dependencies
RUN tlmgr install gitinfo-lua lua-placeholders regulatory

USER ltxuser

# TODO: install XDP from source