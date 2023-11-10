# Juniper Telemetry Stack - aka. JTS
This is a repo to build from scratch a Telemetry stack to monitor any Juniper Routing Devices. 

This stack has the codename "JTS" which stands for Juniper Telemetry Stack 

This stack relies on OpenSource software solutions such as **Telegraf** for collecting gNMI Telemetry state data and pre-processing the data, **InfluxDB** as a Time Series Database to store data, **Kapacitor** to aggregate and perform Alarming and finally **Grafana** to display contents. A specific piece of software developed by Juniper and called **JTSO**, which stands for JTS Orchestrator, is also present in the stack (Dev. in **GOLANG**). This piece of software developed by TME AWAN Team has 2 main roles: the first one is to manage the Stack (provision routers IP, select the pre shipped profils) and on the other hands provide an Enricher tool to enrich on-the-fly telemetry data for better visualization and aggregation).  

JTS is pre-filled with templates of configuration and dashbords for typical use cases. Those profiles are tgz files store in compose/jso/profiles directory 

JTS relies on Docker Compose to deploy in one command this stack. Please be sure you have done all the prerequisites before. Check [Here](./setup.md)

JTS has only been validated for Ubuntu/Debian Host OS. 

{- Notice: Currently JTS uses a specific build of Telegraf which offers more functionalities (dev. by Juniper). Juniper will continue to push these enhancements to the official Telegraf project -}

![jts.png](./img/JTS.png)

## API diagram

## Installation of JTS

Just clone the git repo locally. 

```shell
# In any directory 
mkdir JTS
cd JTS

git clone https://auto-vm.englab.juniper.net/door7302/jts .
```

## Start JTS 

To start the JTS you just need to deploy each docker by using **docker compose up** command. 

If you want to use HTTPs for JTSO and Grafane you may use self signed certificate:

```shell
#Go to the jtso/cert directpory 
cd ./compose/jtso/cert 

openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096

openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key

rm server.pass.key

openssl req -new -key server.key -out server.csr

openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```

Now, edit the JTSO config file and enable JTSO HTTPS 

```shell
vi ./compose/jtso/config.yml
/.../
modules:
  portal:
    https: true
    server_crt: "server.crt"
    server_key: "server.key"
/.../
```

Now copy server.key & server.crt into ./compose/grafana/cert 

```shell
cd ./compose/jtso/cert 
cp server.* ../../grafana/cert
```
Finally, update the ./compose/grafana/grafana.ini config file like that:

```shell
vi ./compose/grafana/grafana.ini 
[server]
# Protocol (http, https, h2, socket)
protocol = https

# https certs & key file
;cert_file = /tmp/server.crt
;cert_key = /tmp/server.key
/.../
```
You can also change the default JTSO & Grafana public facing port (see below) by editing ./compose/.env file 

You can change public ports facing by editing before the **.env**  file. Three ports are exposed:
- GRAFANA_PORT: the port used to reach the Grafana portal
- JTSO_PORT: the port used to reach the JTSO portal

{- The first time you bring up the stack, it may take slightly more time as we need to build on-the-fly Telegraf -} 

```shell
# If needed, You can change public ports facing by editing the .env file 
cat .env
GRAFANA_PORT=8080
JTSO_PORT=80
```

If you change the GRAFANA public facing port you also need to update the jtso config.yml with the same port, like that:

```shell
vi ./compose/jtso/config.yml
/.../
modules:
  grafana:
    port: 8080
/.../
```

If you want to use SSL for gNMI (global to all router) you need first to create a self signed CA: **Keep the naming convention**

```shell
cd ./compose/telegraf/cert
openssl genrsa -out RootCA.key 2048
openssl req -x509 -new -key RootCA.key -days 3650 -out RootCA.crt
```

Now, create and sign telegraf certificates:

```shell
openssl genrsa -out client.key 2048 
openssl req -new -key client.key -out client.csr
openssl x509 -req -in client.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out client.crt -days 365

```

And finally for each router - repeat these following task - to create and sign the router certificate:

```shell
openssl genrsa -out router.key 2048 
openssl req -new -key router.key -out router.csr
openssl x509 -req -in router.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out router.crt -days 365
cat router.crt router.key > router.pem
```

Upload to the router the router.pem, client.crt and RootCA.crt into one router folder (i.e. /var/tmp), and do this configuration on each router:


```junos
edit exclusive
set security pki ca-profile ca1 ca-identity caid1
set security certificates local lcert load-key-file /var/tmp/router.pem
commit and-quit
request security pki ca-certificate load ca-profile ca1 filename /var/tmp/RootCA.crt
```

Now, you can start the OpenJTS with the following command: 
```shell 
# Bring up the stack with one Telegraf Instance
docker compose up -d  

```

You may want to check if all dockers are up and running. For that, just issue the following command:

```shell
docker compose ps
```

## Stop JTS

To stop the JTS just issue the following command:

```shell
# Shutdown the stack
docker compose down
```



