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

From root - create a username openjts 

```shell
adduser openjts
# add openjts as sudoer 
adduser openjts sudo  
```

Now, switch to openjts user
```shell
su openjts
```

Just clone the git repo locally. 

```shell
# In any directory 
sudo mkdir JTS
cd JTS

sudo git clone https://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@github.com/door7302/openjts.git .
```

## Configuration of JTS 

### Prefer HTTPS ? 

If you want to use HTTPs for JTSO and Grafane you may use self signed certificate:

```shell
#Go to the jtso/cert directpory 
cd ./compose/jtso/cert 

sudo openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096

sudo openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key

sudo rm server.pass.key

sudo openssl req -new -key server.key -out server.csr

sudo openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```

Now, edit the JTSO config file and enable JTSO HTTPS (set to true)

```shell
sudo vi ./compose/jtso/config.yml
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
sudo cp server.* ../../grafana/cert
```
Finally, update the ./compose/grafana/grafana.ini config file like that:

```shell
sudo vi ./compose/grafana/grafana.ini 
[server]
# Protocol (http, https, h2, socket)
protocol = https

# https certs & key file
cert_file = /tmp/server.crt
cert_key = /tmp/server.key
/.../
```

### Incoming ports to open 

By default, the JTSO portal listen to TCP port 80 and Grafana to TCP 8080. You can also change the default JTSO & Grafana public facing port (see below) by editing ./compose/.env file before starting the stack.

You can change public ports facing by editing the **.env**  file. Two ports are exposed:
- GRAFANA_PORT: the port used to reach the Grafana portal - default is 8080
- JTSO_PORT: the port used to reach the JTSO portal  - default is 80

```shell
# If needed, You can change public ports facing by editing the .env file 
cat .env
GRAFANA_PORT=8080
JTSO_PORT=80
```

If you change the GRAFANA public facing port you also need to update the jtso config.yml with the same port, like that:

```shell
sudo vi ./compose/jtso/config.yml
/.../
modules:
  grafana:
    port: 8080
/.../
```

### Outgoing ports to open

OpenJTS will establish TCP sessions with your routing devices for reaching the following network services:
- Netconf - default is TCP port 830
- gNMI - default is TCP 9339

If needed you can change these ports. 

#### Netconf port

By default OpenJTS uses the Netconf port 830. If you want to change this port you need to edit the jtso config file:

```shell
sudo vi ./compose/jtso/config.yml
/.../
protocols:
  netconf:
    port: 9339
/.../
```

#### gNMI port

By default OpenJTS uses the gRPC port 9339. If you want to change this port you need to edit the jtso config file:

```shell
sudo vi ./compose/jtso/config.yml
/.../
protocols:
  gnmi:
    port: 9339
/.../
```

### gNMI with TLS 

If you want to use SSL for gNMI (**global to all routers**) you need first to create a self signed CA: **Keep the naming convention**

```shell
cd ./compose/telegraf/cert
sudo openssl genrsa -out RootCA.key 2048
sudo openssl req -x509 -new -key RootCA.key -days 3650 -out RootCA.crt
```

Now, create and sign telegraf certificates:

```shell
sudo openssl genrsa -out client.key 2048 
sudo openssl req -new -key client.key -out client.csr
sudo openssl x509 -req -in client.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out client.crt -days 365

```

And finally for each router - repeat these following task - to create and sign the router certificate:

```shell
sudo openssl genrsa -out router.key 2048 
sudo openssl req -new -key router.key -out router.csr
sudo openssl x509 -req -in router.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out router.crt -days 365
cat router.crt router.key > router.pem
```

Upload to the router the **router.pem**, **client.crt** and **RootCA.crt** into one router folder (i.e. /var/tmp), and do this configuration on each router:

```junos
edit exclusive
set security pki ca-profile ca1 ca-identity caid1
set security certificates local lcert load-key-file /var/tmp/router.pem
commit and-quit
request security pki ca-certificate load ca-profile ca1 filename /var/tmp/RootCA.crt
```

### Configure your network devices

For each routing device apply these config lines:

```junos
edit exclusive

# Netconf User
set system login user netconf_user class super-user
set system login user netconf_user authentication encrypted-password “”

#gNMI User 
set system login user gnmi_user class super-user
set system login user gnmi_user authentication encrypted-password “”

# Clear Text gRPC
set system services extension-service request-response grpc clear-text port 9339
set system services extension-service request-response grpc max-connections 8
set system services extension-service request-response grpc skip-authentication

# Or TLS encryption gRPC
set system services extension-service request-response grpc ssl port 9339
set system services extension-service request-response grpc ssl local-certificate lcert
set system services extension-service request-response grpc ssl mutual-authentication certificate-authority ca1
set system services extension-service request-response grpc ssl mutual-authentication client-certificate-request require-certificate-and-verify

# Netconf
set system services netconf ssh
set system services netconf rfc-compliant #optional

commit and-quit
```

## Start JTS 

To start the JTS you just need to deploy each docker by using **docker compose up** command. 

You can start the OpenJTS with the following command:

{- The first time you bring up the stack, it may take slightly more time as we need to build on-the-fly Telegraf -} 

```shell 
# Bring up the stack with one Telegraf Instance
sudo docker compose up -d  
```

You may want to check if dockers are up and running. For that, just issue the following command:

```shell
sudo docker compose ps
```

Note: Telegraf docker(s) are only started if there is at least one router assigned to the Telegraf instance. 

## Stop JTS

To stop the JTS just issue the following command:

```shell
# Shutdown the stack
sudo docker compose down
```

## Update the JTSO 

To update the JTSO image 

```shell
# Shutdown the stack
sudo docker compose down

# remove the current image 
sudo docker image rm compose-jtso 

# restart the stack 
sudo docker compose up -d  
```


