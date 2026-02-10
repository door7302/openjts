# Installation

## Prerequisites

Follow the official Docker documentation for Ubuntu:

https://docs.docker.com/engine/install/ubuntu/

Then execute the following commands:

```shell
sudo umask 022

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### First-Time Docker Login

You must authenticate once to download images from Docker Hub:

```shell
docker login --username <your-username>
```

### Verify Installation

Run the following test container:

```shell
docker run hello-world
```

If everything is working properly, Docker should display a confirmation message.

## Install OpenJTS

### 1. Create a Dedicated User

From the root account, create a dedicated user for OpenJTS:

```shell
adduser openjts
adduser openjts sudo
```

### 2. Switch to the New User

```shell
su - openjts
```

### 3. Clone the Repository

Create a working directory and clone the OpenJTS repository:

```shell
mkdir -p ~/JTS
cd ~/JTS

git clone https://github.com/door7302/openjts .
```

> **Note:** The last dot "." is useful. Don't miss it. 

### 4. Build the Stack

Navigate to the `compose` directory and build all containers:

```shell
cd compose
docker compose build --no-cache
```

The stack images will now be built locally. You are ready to proceed with the configuration phase.