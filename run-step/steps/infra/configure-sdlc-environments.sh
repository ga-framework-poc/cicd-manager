#!/usr/bin/bash

set -ex

echo 'Create OCP SDLC Environments'

ENV_ARRAY=(${DEV_ENVIRONMENT}  $(echo ${TEST_ENVIRONMENTS} | jq -jr  '.[] + " "'))
RQ_COUNTER=1
for ENV in ${ENV_ARRAY}
do
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${ENV}"
    if [[ -z $(oc get --ignore-not-found --no-headers project ${OCP_PROJECT_NAME}) ]]
    then
        echo 'dev OCP Project not found: CREATING'
        oc new-project ${OCP_PROJECT_NAME}
    else
        echo "${ENV} OCP Project ${OCP_PROJECT_NAME} found: SKIPPING"
    fi

    oc delete quota --wait --ignore-not-found -l systemid=${SYSTEM_NAME} -n ${OCP_PROJECT_NAME}
    sleep 2

    RQ_SIZE=$(echo ${RESOURCE_QUOTAS} | jq -r .${ENV})
    RQ_FILE="${GITHUB_ACTION_PATH}/resources/resource-quotas/${RQ_SIZE}.yml"
    if [[ ! -z "${RQ_SIZE}" && -f "${RQ_FILE}" ]]
    then
        oc create -f ${RQ_FILE}
        oc label systemid=${SYSTEM_NAME} -f ${RQ_FILE} -n ${OCP_PROJECT_NAME}
    fi
done

set +ex