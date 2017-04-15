FROM blitznote/debootstrap-amd64:16.04
MAINTAINER Karl Tiedt <ktiedt@gmail.com>
#Based on the work of needo <needo@superhero.org>
#ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME            /root

# Add a my user, which we'll reuse for all HTPC containers, and set UID predictable value
RUN useradd ktiedt -u 1000 \
    && apt-get update -q && apt-get install -qy \
    software-properties-common \
    && add-apt-repository ppa:jcfp/ppa \
    && add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ xenial universe multiverse" \
    && add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe multiverse" \
    && add-apt-repository ppa:mc3man/xerus-media \
    && apt-get update -q && apt-get install -qy --allow-unauthenticated \
        unrar \
        sabnzbdplus \
        ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Setup runit and install multithreaded prebuilt par2 w/tbb support (multi core)
COPY ["par2", "sabnzbd.sh", "/tmp/"]
RUN mkdir /etc/service/sabnzbd \
    && mv /tmp/sabnzbd.sh /etc/service/sabnzbd/run \
    && chmod +x /etc/service/sabnzbd/run \
    && mv /tmp/par2 /usr/bin \
    && ln -f /usr/bin/par2 /usr/bin/par2create \
    && ln -f /usr/bin/par2 /usr/bin/par2verify \
    && ln -f /usr/bin/par2 /usr/bin/par2repair 

# Path to a directory that only contains the sabnzbd.conf
VOLUME /config
VOLUME /media

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "/etc/service/sabnzbd/run"]
