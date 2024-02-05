# Update the stack 

 **Table of content:**
 - [Home](README.md)
 - [Installation](INSTALL.md)
 - [Configuration](CONFIG.md)
 - [Update Stack](UPDATE.md)
 - [Utilization](USAGE.md)
 - [Profiles documentation](PROFILES.md)
 
## Update JTS 

To update the stack - first of all stop the stack:

```shell
docker compose down
```

Then issue a git pull:

```shell
git pull

# if errors occured you can issue a stash before:

git stash 
git pull 
```

Finally, restart the stack 

```shell
docker compose up -d 
```

## Update the JTSO container 

Sometimes it will useful to download and compile the lastest image of the JTSO container. For that, first stop the stack:

```shell
docker compose down
```

Then delete your local JTSO container image

```shell
docker image rm compose-jtso
```

And finally, restart the stack. The restart could take a bit more time as docker needs to download and compile the new version of JTSO. 

```shell
docker compose up -d 
```

## Update the Telegraf instance used by OPENJTS

OpenJTS uses a fork of the telegraf project. Sometimes it will useful to download and compile the lastest image of the Telegraf container. For that, first stop the stack:

```shell
docker compose down
```

Then delete your local Telegraf container images - one per platform

```shell
docker image rm compose-telegraf_vmx
docker image rm compose-telegraf_mx
docker image rm compose-telegraf_ptx
docker image rm compose-telegraf_acx
```

And finally, restart the stack. The restart could take a bit more time as docker needs to download and compile the new version of Telegraf. 

```shell
docker compose up -d 
```