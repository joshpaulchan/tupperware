# the cloud-sdk image is a Debian based
# https://cloud.google.com/sdk/docs/downloads-docker
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:322.0.0

# Few more components we can use:
# https://cloud.google.com/sdk/docs/components

# RUN gcloud components install kubectl

# helm from here
# https://helm.sh/docs/intro/install/#from-script

# believe this version has to be the git tag?
RUN DESIRED_VERSION=v3.8.0 curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
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
# sops download url retrieved from https://github.com/mozilla/sops/releases
# curl -f (fail early) -s (silent) -S (show errors tho) -L (follow redirects) hugely important here otherwise won't redirect to true asset location
ARG SOPS_VERSION=3.7.1
ARG HELM_SECRETS_VERSION=v3.8.2
RUN curl -fsSL  -o sops.deb https://github.com/mozilla/sops/releases/download/v$SOPS_VERSION/sops_$SOPS_VERSION\_amd64.deb \
    && apt install ./sops.deb \
    && helm plugin install https://github.com/jkroepke/helm-secrets --version $HELM_SECRETS_VERSION
