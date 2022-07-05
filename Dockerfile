ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"

FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# We don't need audio
ENV START_PULSEAUDIO 0
ENV KASM_SVC_AUDIO 0
ENV KASM_SVC_AUDIO_INPUT 0

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wine-development

RUN export WINBOX_URL=$(curl -s -L https://mt.lv/winbox64 -o /dev/null -w '%{url_effective}') && \
    echo ${WINBOX_URL} > /winbox_url
ADD --chown=1000:0 ${WINBOX_URL} /opt/winbox/winbox64.exe

ADD startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh


# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ && \
    cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

ADD winetricks_install.sh /tmp
RUN bash /tmp/winetricks_install.sh && \
    update_winetricks
######### End Customizations ###########

WORKDIR $HOME
RUN mkdir -p $HOME/.wine && chown -R 1000:0 $HOME

USER 1000
