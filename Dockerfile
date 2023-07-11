FROM gitpod/openvscode-server:latest

USER root
RUN apt-get update && apt-get install -y wget apt-transport-https && \
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /usr/share/keyrings/adoptium.asc && \
    echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && apt-get install -y git openssh-client openssh-server bash libsecret-1-0 temurin-17-jdk maven && \
    apt-get purge -y wget && \
    apt-get clean
USER openvscode-server
