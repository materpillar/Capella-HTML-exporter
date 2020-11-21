FROM ubuntu

ARG CAPELLA_ZIP=https://download.eclipse.org/capella/core/products/releases/1.4.2-R20201014-090868/capella-1.4.2.202010140908-linux-gtk-x86_64.zip
ARG HTML_EX_ZIP=https://download.eclipse.org/capella/addons/xhtmldocgen/dropins/release/1.4.3/CapellaXHTMLDocGen-1.4.3.202011061621-Capella-1.4.2-dropins.zip

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -qq \
    wget unzip openjdk-8-jre-headless libgtk-3-dev xvfb dbus-x11 && \
    rm -rf /var/lib/apt/lists/*

# This x11 stuff we apparently don't need:
#RUN apt-get install -qq x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps

WORKDIR /opt
RUN wget -nv -c ${CAPELLA_ZIP} -O capella.zip
RUN unzip capella.zip && rm capella.zip && chmod a+x capella/eclipse/eclipse

WORKDIR /opt/capella/eclipse/dropins
RUN wget -nv -c ${HTML_EX_ZIP} -O capella-html-export.zip
RUN unzip capella-html-export.zip && rm capella-html-export.zip

ENV PATH="/opt/capella/eclipse/:${PATH}"

WORKDIR /workdir
ENTRYPOINT ["./entrypoint.sh"]

