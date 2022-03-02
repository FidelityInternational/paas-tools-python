FROM python:3.9-buster
ENV CF_CLI_VERSION="7.2.0"
ENV YQ_VERSION="4.9.6"
ENV CF_MGMT_VERSION="v1.0.51"
ENV BOSH_VERSION="6.4.4"
ENV CREDHUB_VERSION="2.9.0"
ENV PACKAGES "awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip sshfs"
RUN apt-get update && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CF_CLI_VERSION}" | tar -zx -C /usr/local/bin && \
    curl -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    curl -L "https://github.com/vmware-tanzu-labs/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-linux" -o /usr/local/bin/cf-mgmt &&\
    curl -L "https://github.com/vmware-tanzu-labs/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-config-linux" -o /usr/local/bin/cf-mgmt-config && \
    curl -L "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && \
    curl -L "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin
RUN chmod +x /usr/local/bin/*
RUN ln /usr/bin/uuidgen /usr/local/bin/uuid
RUN mkdir -p /root/.ssh
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir aws-adfs PyJWT pyyaml requests bs4 ruamel.yaml regex awscli retrying boto3 botocore certbot git+https://github.com/FidelityInternational/certbot-dns-qip.git
RUN git config --global user.email "git-ssh@example.com"
RUN git config --global user.name "Docker container git-ssh"
