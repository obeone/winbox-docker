# syntax = docker/dockerfile:1.4
ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"

FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

# Using build cache to speed up the build process
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache


ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# We don't need audio
ENV START_PULSEAUDIO 0
ENV KASM_SVC_AUDIO 0
ENV KASM_SVC_AUDIO_INPUT 0

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get dist-upgrade --no-install-recommends -y && \
    apt-get install -y --no-install-recommends wine-development && \
    apt-get autoremove -y && \
    apt-get autoclean -y

COPY --chmod=0755 winbox_download.sh /tmp
RUN /tmp/winbox_download.sh

COPY --chmod=0755 startup.sh $STARTUPDIR/custom_startup.sh

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ && \
    cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get remove -y xfce4-panel

COPY --chmod=0755 winetricks_install.sh /tmp
RUN bash /tmp/winetricks_install.sh && \
    update_winetricks
######### End Customizations ###########

WORKDIR $HOME
RUN mkdir -p $HOME/.wine && chown -R 1000:0 $HOME

USER 1000

LABEL org.opencontainers.image.title="Winbox"
LABEL org.opencontainers.image.description="Use Mikrotik's Winbox with your browser !"
LABEL org.opencontainers.image.vendor="Mikrotik"
LABEL org.opencontainers.image.authors="Grégoire Compagnon <obeone@obeone.org>"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.source="https://github.com/obeone/winbox-mikrotik"
