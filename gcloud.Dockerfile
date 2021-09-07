# the cloud-sdk image is a Debian based
# https://cloud.google.com/sdk/docs/downloads-docker
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:322.0.0-slim

# Few more components we can use:
# https://cloud.google.com/sdk/docs/components

ARG INSTALL_COMPONENTS=kubectl
# RUN gcloud components install kubectl

# helm from here
# https://helm.sh/docs/intro/install/#from-script

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm ./get_helm.sh

# throw gh in here too why not
# https://cli.github.com/manual/installation
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update --allow-releaseinfo-change \
    && apt install gh

# make it secrets ready
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version v3.8.2
