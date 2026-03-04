# Update the Stack

## Update JTS Containers

To update OpenJTS, follow the steps below.

### 1. Stop the Stack

```shell
docker compose down
```

### 2. Pull the Latest Changes

```shell
git pull
```

If you encounter local modification conflicts, you can stash your changes first:

```shell
git stash
git pull
```

### 3. Remove Old Images

Remove the previously built images to ensure a clean rebuild:

```shell
docker image rm jtso -f
docker image rm jts_telegraf -f
```

### 4. Rebuild Containers

```shell
docker compose build --no-cache
```

This forces Docker to rebuild all images without using cached layers.

### 5. Restart the Stack

```shell
docker compose up -d
```

The stack is now updated and running with the latest version.

### 6. Version Checking

Version of each OpenJTS component is visible at the bottom of the main UI page:

![jts.png](./img/version.png)