# Creation of kubernetes yaml files
Basic idea is to create the pod / containers manually with run commands. After that it is possible to
create a kubernetes yaml file out of it.

## Create pod
Creation of the pod with the following command:
``` bash
podman pod create \
  --name <name> <additional>
```

Please consider to define here the ports which shall be available to the outside of the pod.

## Add container to pod
``` bash
podman create \
  --label io.containers.autoupdate=registry
  --pod <name> \
  --name backend \
  --restart=no \
  <image>
```
Please consider here to change the restart policy in order to let systemd take care of it. Repeat this step with all necessary container. The label defines, that all containers in the pod are allowed to be updated automatically if a new image is available in the registry. You can move it to the container, if you only allow to certain containers inside the pod or remove if you do not allow auto update.


## Generate kubernetes file from pod
``` bash
podman generate kube <podname> -f <kubernetes_file_path>.yaml
```

## Remove pod
``` bash
podman pod rm <name>
```

## Run pod as systemd service (start/enable)
There are several ways to archieve this. My preference is here to apply a podman-kube systemd template to let the service run.

The call is a little bit inconvenient, but you will have the benefit, that on changes of the service unit or functional enhancements, you do not need to change anything, since it is defined in the template itself.

``` bash
escaped=$(systemd-escape <kubernetes_file_path>.yaml)
systemctl --user start podman-kube@$escaped.service
systemctl --user enable podman-kube@$escaped.service
```
The idea is here, that the template *podman-kube* is applied to the kubernetes file (absolute path is required). Since systemd cannot handle file path characters (e.g. "/" or " "), you need to escape the path before.

## Activate auto-updates
``` bash
systemctl --user enable --now podman-auto-update.timer
```
# Handling of secrets
If you want to avoid writing login information in cleartext in the kubernetes file or run command, you can use podman secrets.

Either create it directly (visible in shell history) or via file

Direct:
``` bash
printf "secret" | podman secret create secretname -
```

via file:
``` bash
echo "secretdata" > secretfile
podman secret create secretname secretfile
```

If you want to use the secret inside the container, you can use
the `--secret <secretname>` inside the run command. If you need to access it, you can find it under `/run/secrets/secretname` inside the container. Also a direct mapping to an environment variable in the run command is possible, e.g. `-e VARIABLE=/run/secrets/secretname`.