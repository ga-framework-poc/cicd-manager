#!/usr/bin/bash

set -ex

oc version
helm version
jq --version

oc login --insecure-skip-tls-verify -u ${OCP_USER} -p ${OCP_CREDS} ${OCP_URL}

ENV_ARRAY=$(echo "${DEV_ENVIRONMENT} $(echo ${TEST_ENVIRONMENTS} | jq -jr  '" " + .[]')" | xargs)
echo "ENV_ARRAY: ${ENV_ARRAY}"
for ENV in ${ENV_ARRAY}
do
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${ENV}"

    SERVICE_ACCOUNT_NAME=${SYSTEM_NAME}-${TEAM_NAME}-service-account
    SA_SECRET_NAME=$(oc get secrets -o custom-columns=:.metadata.name | grep -m 1 ${SERVICE_ACCOUNT_NAME}-token)
    SA_TOKEN="::add-mask::{$(oc get secrets ${SA_SECRET_NAME} -o custom-columns=:.data.token | tr -d '[:space:]')}"
    SA_TOKEN_DECODE="::add-mask::{$(echo ${SA_TOKEN} | base64 -s)}"

    oc login --token=${SA_TOKEN_DECODE} ${OCP_URL}

    gh secret set OCP_SA_TOKEN --body "${SA_TOKEN_DECODE}" -R ${REPO_NAMES}
done

set +ex
