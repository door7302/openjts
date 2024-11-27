# Update the stack 

 **Table of content:**
 - [Home](README.md)
 - [Installation](INSTALL.md)
 - [Configuration](CONFIG.md)
 - [Update Stack](UPDATE.md)
 - [Utilization](USAGE.md)
 - [Profiles documentation](PROFILES.md)
 
## Update JTS containers

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

Finally, rebuild the containers 

```shell 
docker compose build --no-cache
``` 

And finally restart the stack 

```shell
docker compose up -d
```
