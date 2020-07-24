FROM python:3.8-buster
ENV CF_CLI_VERSION="6.51.0"
ENV YQ_VERSION="3.2.1"
ENV CF_MGMT_VERSION="v1.0.43"
ENV BOSH_VERSION="6.2.1"
ENV PACKAGES "awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip"
RUN apt-get update && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -L "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v${CF_CLI_VERSION}/cf-cli_${CF_CLI_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin && \
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o yq && chmod +x yq && mv yq /usr/local/bin/yq && \
    ln -s /usr/local/bin/yq /usr/local/bin/yaml && \
    curl -L "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-linux" -o /usr/local/bin/cf-mgmt && chmod +x /usr/local/bin/cf-mgmt && \
    curl -L "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-config-linux" -o /usr/local/bin/cf-mgmt-config && chmod +x /usr/local/bin/cf-mgmt-config && \
    curl -L "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && chmod +x /usr/local/bin/bosh && \
    ln /usr/bin/uuidgen /usr/local/bin/uuid && \
    cf install-plugin -r CF-Community -f "blue-green-deploy" && \
    cf install-plugin -r CF-Community -f "autopilot" && \
    curl -L https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.6.2/credhub-linux-2.6.2.tgz -o credhub-linux-2.6.2.tgz && \
    tar xvf credhub-linux-2.6.2.tgz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/credhub && \
    rm credhub-linux-2.6.2.tgz && \
    mkdir -p /root/.ssh && \
    git config --global user.email "git-ssh@example.com" && \
    git config --global user.name "Docker container git-ssh"
