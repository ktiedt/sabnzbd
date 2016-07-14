FROM phusion/baseimage:0.9.16
MAINTAINER Karl Tiedt <ktiedt@gmail.com>
#Based on the work of needo <needo@superhero.org>
#ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add a my user, which we'll reuse for all HTPC containers, and set UID predictable value (the meaning of 2 lives)
RUN useradd ktiedt -u 1000

RUN add-apt-repository ppa:jcfp/ppa
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN add-apt-repository ppa:mc3man/trusty-media
RUN apt-get update -q
RUN apt-get install -qy unrar par2 sabnzbdplus wget ffmpeg 

# Install multithreaded par2 from source
#RUN apt-get remove --purge -y par2
#ADD par2 /usr/bin
#RUN ln -f /usr/bin/par2 /usr/bin/par2create
#RUN ln -f /usr/bin/par2 /usr/bin/par2verify
#RUN ln -f /usr/bin/par2 /usr/bin/par2repair

# Path to a directory that only contains the sabnzbd.conf
VOLUME /config
VOLUME /home/ktiedt/Plex

EXPOSE 8080

# Add sabnzbd to runit
RUN mkdir /etc/service/sabnzbd
ADD sabnzbd.sh /etc/service/sabnzbd/run
RUN chmod +x /etc/service/sabnzbd/run
