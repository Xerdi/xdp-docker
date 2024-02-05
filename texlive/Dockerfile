ARG FROM=ubuntu:22.04
FROM $FROM
MAINTAINER Erik Nijenhuis <info@xerdi.com>
ARG profile=texlive.profile

ENV YEAR 2024
ENV TEXLIVE_INSTALL_ENV_NOCHECK 1
ENV TEXLIVE_INSTALL_NO_RESUME 1
ENV TEXLIVE_INSTALL_NO_WELCOME 1

# Install core packages
RUN apt update -q && \
    apt install -qy build-essential wget perl-base libfontconfig1 fontconfig && \
    rm -rf /var/lib/apt/lists/*

# Prepare installation directory
RUN mkdir -p /texlive-setup/install-tl
WORKDIR /texlive-setup

# Download TeX Live
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz;

# Install TeX Live
RUN tar -xvf install-tl-unx.tar.gz -C ./install-tl --strip-components=1;
RUN echo THE PROFILE $profile
COPY profiles/$profile /texlive-setup/texlive.profile
WORKDIR /texlive-setup/install-tl
RUN cat /texlive-setup/texlive.profile
RUN ./install-tl --profile=../texlive.profile

# Cleanup
RUN rm -rf /texlive-setup

RUN tlmgr update --all;
