# Configuration of OpenJTS

## Change the APP_SECRET

Gnmi and Netconf passwords are encrypted into the DB. JTSO uses an external secret that could be changed if needed. For that edit the `.env` file:

```shell
vi compose/.env

[...]
APP_SECRET="DEFAULT_APP_SECRET_CHANGE_ME"
[...]
```

A change of the secret requires a reboot of the stack (if this one was running during the modification):

```shell
cd compose/

docker compose down
docker compose up -d
```

## Enable HTTPS (Optional)

If you want to enable HTTPS for both **JTSO** and **Grafana**, you can generate a self-signed certificate (see below) or use your own certificate.

### 1. Generate Self-Signed Certificates

```shell
# Go to the jtso certificate directory
cd ./compose/jtso/cert

sudo openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096
sudo openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key
sudo rm server.pass.key

sudo openssl req -new -key server.key -out server.csr
```

You will be prompted to enter certificate information:

```shell
Country Name (2 letter code) [AU]: FR
State or Province Name (full name) [Some-State]: France
Locality Name (eg, city) []: Paris
Organization Name (eg, company) [Internet Widgits Pty Ltd]: Juniper
Organizational Unit Name (eg, section) []: AWAN
Common Name (e.g. server FQDN or YOUR name) []: myserver
Email Address []: xxx@yyy.com
```

Then generate the certificate:

```shell
sudo openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```

### 2. Enable HTTPS in JTSO

Edit the JTSO configuration file:

```shell
sudo vi compose/jtso/config.yml
```

Update the portal module by setting `https` to `true`:

```yaml
modules:
  portal:
    https: true
    server_crt: "server.crt"
    server_key: "server.key"
```

Then change the JTSO port from 80 to 443 in `.env` file

```shell
vi compose/.env

[...]
JTSO_PORT=443
[...]
```

You must restart the stack then (if this one was running during the modification):

```shell
cd compose/

docker compose down
docker compose up -d
```

### 3. Copy Certificates to Grafana Cert Folder

```shell
cd compose/jtso/cert
sudo cp server.* ../../grafana/cert
```

### 4. Enable HTTPS in Grafana

Edit the Grafana configuration file:

```shell
sudo vi compose/grafana/grafana.ini
```

Update the server section like that:

```ini
[server]
protocol = https
cert_file = /tmp/server.crt
cert_key = /tmp/server.key
```

You must restart the Grafana container then (if this one was running during the modification):

```shell
cd compose/

docker compose restart grafana
```

## Incoming Ports

By default:

- **JTSO Portal** → TCP port 80
- **Grafana** → TCP port 8080
- **Chronograf** → TCP port 8080

You can modify these public-facing ports by editing the `.env` file before starting the stack.

```shell
cat compose/.env

GRAFANA_PORT=8080
CHRONOGRAF_PORT=8081
JTSO_PORT=80
```

If you change the **Grafana public port**, you must also update the JTSO configuration:

```shell
sudo vi compose/jtso/config.yml
```

```yaml
modules:
  grafana:
    port: 8080
```

You must restart the Grafana container then (if this one was running during the modification):

```shell
cd compose/

docker compose restart grafana
```

## Outgoing Ports

OpenJTS establishes TCP sessions toward routing devices for:

- **NETCONF** → default TCP 830
- **gNMI (gRPC)** → default TCP 9339

These ports can be modified if required. Once modified, it requires to restart JTSO - don't forget to modify your router's config as well. 

```shell
cd compose/

docker compose restart jtso
```

### Change NETCONF Port

Edit:

```shell
sudo vi compose/jtso/config.yml
```

And modify the netconf port: 

```yaml
protocols:
  netconf:
    port: 830
```

### Change gNMI Port

Edit:

```shell
sudo vi compose/jtso/config.yml
```

And modify the gNMI port: 

```yaml
protocols:
  gnmi:
    port: 9339
```

## gNMI with TLS (Global Configuration)

To enable TLS for gNMI across all routers, create a self-signed CA.  
⚠️ Keep the naming convention as shown below.

### 1. Create Root CA

```shell
cd compose/telegraf/cert

sudo openssl genrsa -out RootCA.key 2048
sudo openssl req -x509 -new -key RootCA.key -days 3650 -out RootCA.crt
```

### 2. (Optional) Generate Telegraf Client Certificate

```shell
sudo openssl genrsa -out client.key 2048
sudo openssl req -new -key client.key -out client.csr
sudo openssl x509 -req -in client.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out client.crt -days 365
```

### 3. Generate Router Certificate (Repeat for Each Router)

```shell
sudo openssl genrsa -out router.key 2048
sudo openssl req -new -key router.key -out router.csr
sudo openssl x509 -req -in router.csr -CA RootCA.crt -CAkey RootCA.key -CAcreateserial -out router.crt -days 365
cat router.crt router.key > router.pem
```

Upload the following files to each router (e.g., `/var/tmp`):

- `router.pem`
- `client.crt`
- `RootCA.crt`

Then apply the following configuration:

```junos
edit exclusive
set security pki ca-profile ca1 ca-identity caid1
set security certificates local lcert load-key-file /var/tmp/router.pem
commit and-quit

request security pki ca-certificate load ca-profile ca1 filename /var/tmp/RootCA.crt
```

## Configure Your Network Devices

Apply this generic configuration on each router

```junos
edit exclusive

# NETCONF User
set system login user netconf_user class super-user
set system login user netconf_user authentication encrypted-password ""

# gNMI User
set system login user gnmi_user class super-user
set system login user gnmi_user authentication encrypted-password ""

# NETCONF SERVICE
set system services netconf ssh
set system services netconf rfc-compliant  # optional

commit and-quit
```

Then prior to **Junos/EVO 25.2** - use this config snippet for configuring gNMI service:

```junos 
edit exclusive

# Clear-text gRPC
set system services extension-service request-response grpc clear-text port 9339
set system services extension-service request-response grpc max-connections 8
set system services extension-service request-response grpc skip-authentication

# OR TLS gRPC
set system services extension-service request-response grpc ssl port 9339
set system services extension-service request-response grpc ssl local-certificate lcert

# Optional mutual authentication - Add:
set system services extension-service request-response grpc ssl mutual-authentication certificate-authority ca1
set system services extension-service request-response grpc ssl mutual-authentication client-certificate-request require-certificate-and-verify

commit and-quit
```

Starting from **Junos/EVO 25.2** I recommend to use this new config snippet: 

```junos 
edit exclusive

# Clear-text gRPC
set system services http servers server MY-SERVER port 9339
set system services http servers server MY-SERVER grpc gnmi
set system services http servers server MY-SERVER clear-text

# OR TLS gRPC
set system services http servers server MY-SERVER port 9339
set system services http servers server MY-SERVER grpc gnmi
set system services http servers server MY-SERVER tls local-certificate lcert

# Optional mutual authentication - Add:
set system services http servers server MY-SERVER tls mutual-authentication certificate-authority ca1
set system services http servers server MY-SERVER tls mutual-authentication authentication-type request-and-require-cert-and-verify

commit and-quit
``` 
