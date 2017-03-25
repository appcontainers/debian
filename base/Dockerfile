###########################################################
# Dockerfile to build Debian 8 Jessie Base Container
# Based on: debian:latest
# DATE: 07/07/15
# COPYRIGHT: Appcontainers.com
###########################################################

# Set the base image in namespace/repo format. 
# To use repos that are not on the docker hub use the example.com/namespace/repo format.
FROM library/debian:latest

# File Author / Maintainer
MAINTAINER Rich Nason rnason@appcontainers.com

###########################################################
#*********************  APP VERSIONS  *********************
###########################################################


###########################################################
#***********  OVERRIDE ENABLED ENV VARIABLES  *************
###########################################################

ENV TERMTAG Debian8Base

###########################################################
#**************  ADD REQUIRED APP FILES  ******************
###########################################################

# Enable Progress Bar
RUN echo 'Dpkg::Progress-Fancy "1";' | tee -a /etc/apt/apt.conf.d/99progressbar

###########################################################
#***************  UPDATES & PRE-REQS  *********************
###########################################################

# Update Base
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils && \
apt-get -y upgrade && \
apt-get clean all && \
rm -fr /var/lib/apt/lists/*

###################################################################
#*******************  APPLICATION INSTALL  ************************
###################################################################


###################################################################
#******************  POST DEPLOY CLEAN UP  ************************
###################################################################

# Strip out Locale data
RUN for x in `ls /usr/share/locale | grep -v en_GB`; do rm -fr /usr/share/locale/$x; done;
RUN for x in `ls /usr/share/i18n/locales/ | grep -v en_`; do rm -fr /usr/share/i18n/locales/$x; done

# Remove Documentation
#RUN find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true && \
#find /usr/share/doc -empty|xargs rmdir || true && \
RUN rm -fr /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

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

# Set the default Timezone to EST
RUN cp /etc/localtime /root/old.timezone && \
rm -f /etc/localtime && \
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Disable IPV6
RUN echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf && \
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf && \
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf && \
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf && \
echo "net.ipv6.conf.eth0.disable_ipv6 = 1" >> /etc/sysctl.conf && \
echo "net.ipv6.conf.eth1.disable_ipv6 = 1" >> /etc/sysctl.conf

###################################################################
#*****************  CONFIGURE START ITEMS  ************************
###################################################################

ADD termcolor.sh /etc/profile.d/PS1.sh
RUN chmod +x /etc/profile.d/PS1.sh && \
echo "source /etc/profile.d/PS1.sh" >> /root/.bashrc && \
echo "source /etc/profile.d/PS1.sh" >> /etc/skel/.bashrc

# Add the following to prevent any additions to the .bashrc from being executed via SSH or SCP sessions
RUN echo "\nif [[ -n \"\$SSH_CLIENT\" || -n \"\$SSH_TTY\" ]]; then\n\treturn;\nfi\n" >> /root/.bashrc && \
echo "\nif [[ -n \"\$SSH_CLIENT\" || -n \"\$SSH_TTY\" ]]; then\n\treturn;\nfi\n" >> /etc/skel/.bashrc

CMD /bin/bash

###################################################################
#****************  EXPOSE APPLICATION PORTS  **********************
###################################################################


###################################################################
#*******************  OPTIONAL / LEGACY  **************************
###################################################################

# Docker doesn't like this way of creating files.
###################################################################
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
###################################################################

# Squash the FS?
#RUN apt-get update && \ 
#apt-get install -y squashfs-tools && \
#rm -fr /var/lib/apt/lists/*

#RUN mkdir -p /debian-build && \
#mksquashfs / /debian-build.sqfs

# Remove Non America TimeZone Data
# This can be undone via: wget 'ftp://elsie.nci.nih.gov/pub/tzdata*.tar.gz'
# RUN for x in `ls /usr/share/zoneinfo|grep -v America`; do rm -fr $x;done;