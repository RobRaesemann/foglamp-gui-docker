FROM nginx:latest

ARG FOGLAMP_DISTRIBUTION
ARG FOGLAMP_PLATFORM
ARG FOGLAMP_VERSION

# Set FogLAMP version, distribution, and platform
ENV FOGLAMP_VERSION=$FOGLAMP_VERSION
ENV FOGLAMP_DISTRIBUTION=$FOGLAMP_DISTRIBUTION
ENV FOGLAMP_PLATFORM=$FOGLAMP_PLATFORM


RUN apt update && \ 
    apt install -y wget
RUN echo http://archives.dianomic.com/foglamp/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/foglamp-gui_${FOGLAMP_VERSION}.deb
RUN wget -q --no-check-certificate http://archives.dianomic.com/foglamp/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/foglamp-gui_${FOGLAMP_VERSION}.deb && \
    # tar -xzvf foglamp.tgz && \
    #dpkg --unpack /foglamp/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/foglamp-gui_${FOGLAMP_VERSION}.deb && \
    dpkg --unpack foglamp-gui_${FOGLAMP_VERSION}.deb && \
    # remove files in the existing NGINX HTML directory
    rm -r /usr/share/nginx/html && \
    # move our FogLAMP GUI files to the NGINX HTML directory
    mv /var/www/html /usr/share/nginx && \
    # The default page from FogLAMP GUI must be renamed to index.html
    mv /usr/share/nginx/html/foglamp.html /usr/share/nginx/html/index.html && \
    # Set the proper owner on our moved files
    chown -R  nginx.nginx /usr/share/nginx/html && \
    # Cleanup FogLAMP installation packages
    rm -f /*.tgz && \ 
    # You may choose to leave the installation packages in the directory in case you need to troubleshoot
    rm -rf -r /foglamp && \
    # General cleanup after using apt
    #apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/ && \
	rm -rf /var/www/

EXPOSE 80

LABEL maintainer="rob@raesemann.com" \
  author="Rob Raesemann" \
  target="Docker" \
  version="${FOGLAMP_VERSION}" \
  description="FogLAMP IIoT Framework GUI"