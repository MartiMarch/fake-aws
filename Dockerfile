FROM localstack/localstack:latest

RUN apt -y update \
&& apt -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg \
     software-properties-common \
&& install -m 0755 -d /etc/apt/keyrings \
&& curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
&& chmod a+r /etc/apt/keyrings/docker.asc \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
&& apt -y update \
&& apt install -y \
     docker-ce \
     docker-ce-cli \
     containerd.io \
     docker-buildx-plugin \
     docker-compose-plugin
