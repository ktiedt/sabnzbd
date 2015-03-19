FROM phusion/baseimage:0.9.16
MAINTAINER David Young <davidy@funkypenguin.co.nz>
#Based on the work of needo <needo@superhero.org>
#ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add a generic htpc user, which we'll reuse for all HTPC containers, and set UID predictable value (the meaning of 2 lives)
RUN useradd htpc -u 4242

RUN add-apt-repository ppa:jcfp/ppa
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN add-apt-repository ppa:jon-severinsson/ffmpeg
RUN apt-get update -q
RUN apt-get install -qy unrar par2 sabnzbdplus wget ffmpeg sabnzbdplus-theme-mobile

# Install multithreaded par2
RUN apt-get remove --purge -y par2
RUN wget -P /tmp http://www.chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20141125-lin64.tar.gz
RUN tar -C /usr/local/bin -xvf /tmp/par2cmdline-0.4-tbb-20141125-lin64.tar.gz --strip-components 1

# Path to a directory that only contains the sabnzbd.conf
VOLUME /config
VOLUME /downloads

EXPOSE 8080

# Add sabnzbd to runit
RUN mkdir /etc/service/sabnzbd
ADD sabnzbd.sh /etc/service/sabnzbd/run
RUN chmod +x /etc/service/sabnzbd/run
