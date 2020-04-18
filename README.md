# Customized Bitnami Tomcat Docker image

* Based of **[Bitnami Tomcat 9.0/debian-10]** **debian-10.0.34-debian-10-r4**
* Added **JDK 1.8.242-0** instead of **JDK 11.0.6-0**
* Added management roles
  * admin-script
  * manager-script
  * manager-jmx
  * manager-status
* Added **TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP** to allow any connection from any IP

## Customizations

### Clone Bitnami Tomcat repo -  9.0.34-debian-10-r4 release

```bash
git clone git@github.com:bitnami/bitnami-docker-tomcat.git
cd bitnami-docker-tomcat
git checkout 8ee5c7c32ad71bc6287c68b304743f2c84964198
cd 9.0/debian-10
```

### Customize JDK version

JDK 1.8 instead of JDK 11.0.6-0

Edit `Dockerfile`

* replace `JDK 11.0.6-0` with `JDK 1.8.242-0`
</br>

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

* add roles:
</br>
  * `admin-script`
  * `manager-script`
  * `manager-jmx`
  * `manager-status`
</br>

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

* add `TOMCAT_ALLOW_REMOTE_MANAGEMENT_ANY_IP`
</br>

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

* add the condition
</br>

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

### Links

[Bitnami Tomcat 9.0/debian-10]

[Bitnami Tomcat 9.0/debian-10]: https://github.com/bitnami/bitnami-docker-tomcat/tree/master/9.0/debian-10