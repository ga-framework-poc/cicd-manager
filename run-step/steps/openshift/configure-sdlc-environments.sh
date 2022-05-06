#!/usr/bin/bash

set -ex

oc login --insecure-skip-tls-verify -u ${{ secrets.OCP_USER }} -p ${{ secrets.OCP_CREDS }} ${{ secrets.OCP_URL }}

echo 'Create OCP SDLC Environments'
ENV_ARRAY=(${DEV_ENVIRONMENT}  $(echo ${TEST_ENVIRONMENTS} | jq -r '.[]'))
RQ_ARRAY=(${DEV_RESOURCEQUOTA}  $(echo ${TEST_RESOURCEQUOTAS} | jq -r '.[]'))
RQ_COUNTER=1
for ENV in ${ENV_ARRAY}
do
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${ENV}"
    if [[ -z $(oc get --ignore-not-found project ${OCP_PROJECT_NAME}) ]]
    then
        echo 'dev OCP Project not found: CREATING'
        oc new-project ${OCP_PROJECT_NAME}
    else
        echo "${ENV} OCP Project ${OCP_PROJECT_NAME} found: SKIPPING"
    fi
    
    oc delete quotas --wait --ignore-not-found
    sleep 2

    if [[ -f "${GITHUB_ACTION_PATH}/resources/resource-quotas/${RQ_ARRAY}.yml" ]]
    the
        oc create -f ${GITHUB_ACTION_PATH}/resources/resource-quotas/${RQ_ARRAY[${RQ_COUNTER}]}.yml
    fi
set +ex