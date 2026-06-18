# Update the Stack

## Update JTS Containers

To update OpenJTS, follow the steps below.

### 1. Stop the Stack

````
docker compose down
````

### 2. Backup enrironment files 

Before upgrading the stack, it is highly recommended to back up the environment and configuration files. Below, we back up everything to the `/tmp/jts-tmp` folder. You may do it by using the `jts_backup.sh` starting from **OpenJTS 1.3.0**:

```shell 
chmod +x jts_backup.sh

./jts_backup.sh backup
```

Or doing it manually:

```shell
mkdir -p /tmp/jts-tmp/

cd $JTSFOLDER

cp compose/.env /tmp/jts-tmp/
cp compose/jtso/db/jtso.db /tmp/jts-tmp/
cp compose/jtso/config.yml /tmp/jts-tmp/
cp compose/grafana/grafana.ini /tmp/jts-tmp/

# Only starting from OpenJTS 1.3.0 and onwards 
cp compose/chronograf/chronograf.ini /tmp/jts-tmp/

# If you use certificates you should also do this
mkdir -p /tmp/jts-tmp/gCerts
mkdir -p /tmp/jts-tmp/jCerts
cp compose/grafana/cert/* /tmp/jts-tmp/gCerts/
cp compose/jtso/cert/* /tmp/jts-tmp/jCerts/
```

### 3. Pull the Latest Changes

````
git pull
````

If you encounter local modification conflicts, you can stash your changes first:

````
git stash
git pull
````

### 4. Remove Old Images

Remove the previously built images to ensure a clean rebuild:

````
docker image rm jtso -f

docker image rm jts_telegraf -f
````

### 5. Rebuild Containers

````
docker compose build --no-cache
````

This forces Docker to rebuild all images without using cached layers.

### 6. Restore environment files 

Once the stack is upgraded, you need to restore the previously backed-up files.  You may do it by using the `jts_backup.sh` starting from **OpenJTS 1.3.0**:

```shell 
chmod +x jts_backup.sh

./jts_backup.sh restore
```

Or doing it manually:

```shell
cd $JTSFOLDER

cp /tmp/jts-tmp/.env compose/
cp /tmp/jts-tmp/jtso.db compose/jtso/db/
cp /tmp/jts-tmp/config.yml compose/jtso/
cp /tmp/jts-tmp/grafana.ini compose/grafana/

# Only starting from OpenJTS 1.3.0 and onwards 
cp /tmp/jts-tmp/chronograf.ini compose/chronograf/

# If you use certificates you should also do this
cp /tmp/jts-tmp/gCerts/* compose/grafana/cert/ert
cp /tmp/jts-tmp/jCerts/* compose/jtso/cert/

rm -rf /tmp/jts-tmp
```

### 7. Restart the Stack

````
docker compose up -d
````

The stack is now updated and running with the latest version.

### 6. Version Checking

Version of each OpenJTS component is visible at the bottom of the main UI page:

![jts.png](./img/version.png)