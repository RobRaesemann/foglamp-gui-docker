FROM nginx:latest

# Set FogLAMP version, distribution, and platform
ENV FOGLAMP_VERSION=1.8.2
ENV FOGLAMP_DISTRIBUTION=ubuntu1804
ENV FOGLAMP_PLATFORM=x86_64

RUN apt update && \ 
    apt install -y wget && \ 
    wget --no-check-certificate https://foglamp.s3.amazonaws.com/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/foglamp-${FOGLAMP_VERSION}_${FOGLAMP_PLATFORM}_${FOGLAMP_DISTRIBUTION}.tgz && \
    tar -xzvf foglamp-${FOGLAMP_VERSION}_${FOGLAMP_PLATFORM}_${FOGLAMP_DISTRIBUTION}.tgz && \
    dpkg --unpack /foglamp/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/foglamp-gui-${FOGLAMP_VERSION}.deb && \
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