############################################################
# Dockerfile to create Debian 8 Jessie Core 
# Based on debian
############################################################

# Set the base image to debian
FROM library/debian:latest

# File Author / Maintainer
MAINTAINER Rich Nason rnason@appcontainers.com

#*************************
#*       Versions        *
#*************************


#**********************************
#* Override Enabled ENV Variables *
#**********************************
ENV TERMTAG DEBIAN8

#**************************
#*   Add Required Files   *
#**************************
ADD termcolor.sh /etc/profile.d/PS1.sh
RUN chmod +x /etc/profile.d/PS1.sh && \
echo "source /etc/profile.d/PS1.sh" >> /root/.bashrc && \
echo "alias vim='nano'" >> /root/.bashrc

#*************************
#*  Update and Pre-Reqs  *
#*************************

# Enable Progress Bar
RUN echo 'Dpkg::Progress-Fancy "1";' | tee -a /etc/apt/apt.conf.d/99progressbar && \

# Update Base
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -y install nano && \
apt-get -y upgrade && \
rm -fr /var/lib/apt/lists/*


#*************************
#*  Application Install  *
#*************************

# Strip out Locale data
RUN for x in `ls /usr/share/locale | grep -v en_GB`; do rm -fr /usr/share/locale/$x; done;

# There are 2 versions of gcc.. so lets get rid of the older one.
# If this causes any issues, it can be readded by apt-get install gcc-4.8-base
RUN echo 'Yes, do as I say!' | apt-get --force-yes remove gcc-4.8-base && \
apt-get purge gcc-4.8-base | exit 0

# Remove Documentation
#RUN find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true && \
#find /usr/share/doc -empty|xargs rmdir || true && \
RUN rm -fr /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

#Prevent other package documentation from being installed
#RUN cat > /etc/dpkg/dpkg.cfg.d/01_nodoc << "EOF"
# This config file will prevent packages from install docs that are not needed.
#path-exclude /usr/share/doc/*
# we need to keep copyright files for legal reasons
# path-include /usr/share/doc/*/copyright
#path-exclude /usr/share/man/*

#path-exclude /usr/share/groff/*
#path-exclude /usr/share/info/*
# lintian stuff is small, but really unnecessary
#path-exclude /usr/share/lintian/*
#path-exclude /usr/share/linda/*
#EOF

# Docker doesn't like the proper way of doing multilined files, so...
RUN echo "# This config file will prevent packages from install docs that are not needed." > /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/doc/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "# we need to keep copyright files for legal reasons" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "# path-include /usr/share/doc/*/copyright" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/man/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/groff/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/info/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "# lintian stuff is small, but really unnecessary" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/lintian/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
echo "path-exclude /usr/share/linda/*" >> /etc/dpkg/dpkg.cfg.d/01_nodoc

#Remove Non America TimeZone Data
# This can be undone via: wget 'ftp://elsie.nci.nih.gov/pub/tzdata*.tar.gz'
RUN for x in `ls /usr/share/zoneinfo|grep -v America`; do rm -fr $x;done;

# Squash the FS?
#RUN apt-get update && \ 
#apt-get install -y squashfs-tools && \
#rm -fr /var/lib/apt/lists/*

#RUN mkdir -p /debian-build && \
#mksquashfs / /debian-build.sqfs

#************************
#* Post Deploy Clean Up *
#************************


#**************************
#*  Config Startup Items  *
#**************************
CMD /bin/bash

#****************************
#* Expose Applicatoin Ports *
#****************************
# Expose ports to other containers only

