# Update the VARIANT arg in devcontainer.json to pick a .NET Core version: 3.1-bionic, 2.1-bionic 
ARG VARIANT="3.1-bionic"
FROM mcr.microsoft.com/dotnet/core/sdk:${VARIANT}

# Options for setup script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE true

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* &&  rm -rf /tmp/library-scripts

# [Optional] Install Node.js for use with web applications - update the INSTALL_NODE arg in devcontainer.json to enable.
ARG INSTALL_NODE="false"
ARG NODE_VERSION="lts/*"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
COPY library-scripts/node-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_NODE" = "true" ]; then /bin/bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"; fi \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Optional] Install the Azure CLI - update the INSTALL_AZURE_CLI arg in devcontainer.json to enable.
ARG INSTALL_AZURE_CLI="false"
RUN if [ "$INSTALL_AZURE_CLI" = "true" ]; then \
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
        && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
        && apt-get update \
        && apt-get install -y azure-cli \
        && rm -rf /var/lib/apt/lists/*; \
    fi

# [Optional] Uncomment this section to install additional OS packages.
 RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends \
     curl \
     git \
     lsb-release \
     lsof \
     net-tools \
     netcat \
     procps \
     traceroute \
     unzip \
     vim \
     wget \
     entr \
     python3-pip \
     less \
     jq \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install aws cli
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws && \
    rm /tmp/awscliv2.zip

# Install latest version of kubectl
RUN cd /tmp && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /tmp/kubectl && \
    mv /tmp/kubectl /usr/local/bin/kubectl

# Install eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Install helm
RUN curl -fsSL -o /tmp/get_helm.sh "https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3" && \
    chmod +x /tmp/get_helm.sh && \
    /tmp/get_helm.sh

RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Install docker
#RUN apt-get purge docker lxc-docker docker-engine docker.io
RUN apt-get update
RUN apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
RUN apt-get update
RUN apt-get install docker-ce docker-ce-cli containerd.io -y
RUN newgrp docker
RUN groupmod -g 998 docker

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
