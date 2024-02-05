# Installation

 **Table of content:**
 - [Home](README.md)
 - [Installation](INSTALL.md)
 - [Configuration](CONFIG.md)
 - [Update Stack](UPDATE.md)
 - [Utilization](USAGE.md)
 - [Profiles documentation](PROFILES.md)

## Install Docker & compose plugin

https://docs.docker.com/engine/install/ubuntu/

```shell
sudo umask 022

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````

Then login first time (requiered for downloading from docker hub):

```shell
docker login --username <your-username>
```

And test: 

```shell
docker run hello-world
```

## Installation of OpenJTS

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

sudo git clone https://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@github.com/door7302/openjts .
```
