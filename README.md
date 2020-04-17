# Customizing Bitnami Tomcat Docker image

## Clone Bitnami Tomcat repo -  9.0.34-debian-10-r4 release

```bash
git clone git@github.com:bitnami/bitnami-docker-tomcat.git
cd bitnami-docker-tomcat
git checkout 8ee5c7c32ad71bc6287c68b304743f2c84964198
cd 9.0/debian-10
```

## Customize JDK version

JDK 1.8 instead of JDK 11.0.6-0

Edit `Dockerfile`, comment out `JDK 11.0.6-0`
and add alternative `JDK 1.8.242-0`

```Dockerfile
FROM docker.io/bitnami/minideb:buster

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.34-0" --checksum 3265bbbb076d08066f7bd5ae0bcbffb5c98b7b78aca857d98f2044f2e900b456
# RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
```

Previous command downloads
[tomcat-9.0.34-0-linux-amd64-debian-10.tar.gz](https://downloads.bitnami.com/files/stacksmith/tomcat-9.0.34-0-linux-amd64-debian-10.tar.gz)


It also downloads [java-1.8.242-0-linux-amd64-debian-10.tar.gz](https://downloads.bitnami.com/files/stacksmith/java-1.8.242-0-linux-amd64-debian-10.tar.gz)

## Add Tomcat management roles to allow CLI operations

Edit `bitnami-docker-tomcat/rootfs/opt/bitnami/scripts/libtomcat.sh`, add
additional roles: `admin-script`,`manager-script`,`manager-jmx`,`manager-status`

```shell
tomcat_create_tomcat_user() {
    local username=${1:?username is missing}
    local password=${2:-}

    local user_definition="<user username=\"${username}\" password=\"${password}\" roles=\"manager-gui,admin-gui,admin-script,manager-script,manager-jmx,manager-status\"/></tomcat-users>"

    replace_in_file "$TOMCAT_USERS_CONF_FILE" "</tomcat-users>" "$user_definition"
}
```

## Allow management operations from any IP address

Edit `bitnami-docker-tomcat/rootfs/opt/bitnami/scripts/libtomcat.sh`, add `export TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP="${TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP:-0}"`

```shell
tomcat_env() {
    cat <<"EOF"
## Exposed

## removed
export TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP="${TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP:-0}"
EOF
}
```

and add condition `if is_boolean_yes "$TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP"; then ...
else fi`

```shell
tomcat_enable_remote_management() {
    ## removed
    if is_boolean_yes "$TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP"; then
        inner_tag=""
    else
        inner_tag=$(tomcat_render_tag Valve "className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"\\\d+\\\.\\\d+\\\.\\\d+\\\.\\\d+\"")
    fi
    ## removed
}
```

## Links

[Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat/tree/master/9.0/debian-10)