FROM docker.io/bitnami/minideb:buster

LABEL Name="bitnami-tomcat9-jdk18" \
    Vendor="com.andriykalashnykov" \
    Maintainer="Andriy Kalashnykov <akalashnykov@vmware.com> (https://github.com/AndriyKalashnykov/)" \
    Version="1.0" \
    License="Apache License, Version 2.0"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libssl1.1 procps sudo unzip zlib1g lsof net-tools
# RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.7-0" --checksum 02a1fc9b79b11617ad39221667f6a34209f5c45ca908268f8ba6c264a2577ee2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
# RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.33-1" --checksum 1de80791756732a32a00e2836101db1dd49da7b1040b35bd9704bab1176d90f9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.34-0" --checksum 3265bbbb076d08066f7bd5ae0bcbffb5c98b7b78aca857d98f2044f2e900b456
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="9.0.34-debian-10-r0" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/common/bin:$PATH"

# RUN mkdir -p /usr/share/tomcat/logs
# RUN chown 1001:1001 -R /usr/share/tomcat/logs

EXPOSE 8080

USER 1001

ENTRYPOINT [ "/opt/bitnami/scripts/tomcat/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]