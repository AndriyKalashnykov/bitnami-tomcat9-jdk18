[![Build Status](https://travis-ci.org/AndriyKalashnykov/bitnami-tomcat9-jdk18.svg?branch=master)](https://travis-ci.org/AndriyKalashnykov/bitnami-tomcat9-jdk18)
[![Docker Pulls](https://img.shields.io/docker/pulls/andriykalashnykov/bitnami-tomcat9-jdk18.svg)](https://hub.docker.com/r/andriykalashnykov/bitnami-tomcat9-jdk18/)
[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# Customized Bitnami Tomcat 9

* Based of **[Bitnami Tomcat 9.0/debian-10]** **debian-10.0.34-debian-10-r4**
* Added **JDK 1.8.242-0** instead of **JDK 11.0.6-0**
* Added [Host Manager Roles] and [Manager Roles]
  * admin-script
  * manager-script
  * manager-jmx
  * manager-status
* Added TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP to [Environment variables].
  Allow to connect to manager applications from **ANY** remote IP addresse. Valid
  values are 0 and 1. Default: 0

## Customizations

### Clone Bitnami Tomcat repo -  9.0.34-debian-10-r4 release

```bash
git clone git@github.com:bitnami/bitnami-docker-tomcat.git
cd bitnami-docker-tomcat
git checkout 8ee5c7c32ad71bc6287c68b304743f2c84964198
cd 9.0/debian-10
```

### Change JDK version

Install JDK 1.8 instead of JDK 11.0.6-0

Edit `Dockerfile`

* [replace `JDK 11.0.6-0` with `JDK 1.8.242-0`]

```Dockerfile
    FROM docker.io/bitnami/minideb:buster

    # removed for brevity

    # RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
    RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400

    # removed for brevity
```

JDK package location: [java-1.8.242-0-linux-amd64-debian-10.tar.gz](https://downloads.bitnami.com/files/stacksmith/java-1.8.242-0-linux-amd64-debian-10.tar.gz)

### Add Tomcat management roles

Edit `bitnami-docker-tomcat/rootfs/opt/bitnami/scripts/libtomcat.sh`

* add [Tomcat Host Manager and Manager Roles]:
  * `admin-script`
  * `manager-script`
  * `manager-jmx`
  * `manager-status`

```shell

    # removed for brevity

    tomcat_create_tomcat_user() {
        local username=${1:?username is missing}
        local password=${2:-}

        local user_definition="<user username=\"${username}\" password=\"${password}\" roles=\"manager-gui,admin-gui,admin-script,manager-script,manager-jmx,manager-status\"/></tomcat-users>"

        replace_in_file "$TOMCAT_USERS_CONF_FILE" "</tomcat-users>" "$user_definition"
    }

    # removed for brevity
```

### Allow management operations from any IP address

Edit `bitnami-docker-tomcat/rootfs/opt/bitnami/scripts/libtomcat.sh`

* [define TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP]

```shell
    # removed for brevity

    tomcat_env() {
        cat <<"EOF"
    ## Exposed

    ## removed
    export TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP="${TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP:-0}"
    EOF
    }

    # removed for brevity
```

* [add condition TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP]

```shell
    # removed for brevity

    tomcat_enable_remote_management() {

        # removed for brevity

        if is_boolean_yes "$TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP"; then
            inner_tag=""
        else
            inner_tag=$(tomcat_render_tag Valve "className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"\\\d+\\\.\\\d+\\\.\\\d+\\\.\\\d+\"")
        fi

        # removed for brevity
    }

    # removed for brevity
```
### bitnami-tomcat9-jdk18 published on DockerHub

* [bitnami-tomcat9-jdk18 on DockerHub]

### Run image

```bash
docker login
docker run --name t9 -d --rm -p 8080:8080 -p 8443:8443 andriykalashnykov/bitnami-tomcat9-jdk18:latest
```

### Test image

```bash
docker exec -t t9 sh -c "cat /opt/bitnami/tomcat/conf/server.xml"
docker exec -t t9 sh -c "cat /opt/bitnami/tomcat/logs/catalina.*.log | grep 'APR'"
docker exec -t t9 sh -c "cat /opt/bitnami/tomcat/conf/tomcat-users.xml | grep 'admin-script'"
docker exec -t t9 sh -c "curl http://localhost:8080/"
```

### Stop image

```bash
docker stop t9
```

### Links

* [Bitnami Tomcat 9.0/debian-10]
* [Bitnami Tomcat]

[Bitnami Tomcat]: https://github.com/bitnami/bitnami-docker-tomcat

[Bitnami Tomcat 9.0/debian-10]: https://github.com/bitnami/bitnami-docker-tomcat/tree/master/9.0/debian-10

[Environment variables]: https://github.com/bitnami/bitnami-docker-tomcat#environment-variables

[Host Manager Roles]: http://tomcat.apache.org/tomcat-9.0-doc/host-manager-howto.html#Configuring_Manager_Application_Access

[Manager Roles]: https://tomcat.apache.org/tomcat-9.0-doc/manager-howto.html#Configuring_Manager_Application_Access

[replace `JDK 11.0.6-0` with `JDK 1.8.242-0`]: https://github.com/AndriyKalashnykov/bitnami-tomcat9-jdk18/blob/eca48b599978add685d52721e3306bad2043eea4/Dockerfile#L17

[Tomcat Host Manager and Manager Roles]: https://github.com/AndriyKalashnykov/bitnami-tomcat9-jdk18/blob/fc9cfc96e3ff1fbfceb4f48bbfb0a7995b1dc8c4/rootfs/opt/bitnami/scripts/libtomcat.sh#L233

[define TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP]: https://github.com/AndriyKalashnykov/bitnami-tomcat9-jdk18/blob/fc9cfc96e3ff1fbfceb4f48bbfb0a7995b1dc8c4/rootfs/opt/bitnami/scripts/libtomcat.sh#L58

[add condition TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP]: https://github.com/AndriyKalashnykov/bitnami-tomcat9-jdk18/blob/fc9cfc96e3ff1fbfceb4f48bbfb0a7995b1dc8c4/rootfs/opt/bitnami/scripts/libtomcat.sh#L209

[bitnami-tomcat9-jdk18 on DockerHub]: https://hub.docker.com/r/andriykalashnykov/bitnami-tomcat9-jdk18
