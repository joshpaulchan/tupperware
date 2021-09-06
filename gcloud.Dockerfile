FROM gcr.io/google.com/cloudsdktool/cloud-sdk:322.0.0-alpine

# Few more components we can use:
# https://cloud.google.com/sdk/docs/components

RUN gcloud components install kubectl

# helm from here: https://helm.sh/docs/intro/install/#from-script

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm ./get_helm.sh
