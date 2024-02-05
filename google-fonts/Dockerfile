ARG FROM=ubuntu:22.04
FROM $FROM

# Download and Install Google Fonts
RUN mkdir -p /google-fonts
WORKDIR /google-fonts
RUN wget https://github.com/google/fonts/archive/main.zip

RUN unzip -d . main.zip; \
    find $PWD/fonts-main/ -iname "*.ttf" -exec install -m644 {} /usr/share/fonts/truetype/google-fonts \; || return 1; \
    find $PWD/fonts-main/ -type f \( -iname \*.otf -o -iname \*.otc \) -exec install -m644 {} /usr/share/fonts/opentype/google-fonts \; || return 1; \
    fc-cache -fv

RUN rm /google-fonts
