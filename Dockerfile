FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -qq \
    wget unzip libgtk-3-dev xvfb dbus-x11 && \
    rm -rf /var/lib/apt/lists/*

# This x11 stuff we apparently don't need:
#RUN apt-get install -qq x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps

ARG CAPELLA_VER=5.1.0
ARG CAPELLA_TAR=https://download.eclipse.org/capella/core/products/releases/5.1.0-R20210615-075512/capella-5.1.0.202106150755-linux-gtk-x86_64.tar.gz
ARG HTML_EX_ZIP=https://download.eclipse.org/capella/addons/xhtmldocgen/dropins/release/5.1.0/CapellaXHTMLDocGen-5.1.0.202106151504-Capella-5.1.0-dropins.zip

WORKDIR /opt/capella-${CAPELLA_VER}
RUN wget -nv -c ${CAPELLA_TAR} -O capella.tar.gz
RUN tar -xzf capella.tar.gz && rm capella.tar.gz

WORKDIR /opt/capella-${CAPELLA_VER}/capella/dropins
RUN wget -nv -c ${HTML_EX_ZIP} -O capella-html-export.zip
RUN unzip capella-html-export.zip && rm capella-html-export.zip

ENV PATH="/opt/capella-${CAPELLA_VER}/capella/:${PATH}"

WORKDIR /workdir
ENTRYPOINT ["./entrypoint.sh"]

