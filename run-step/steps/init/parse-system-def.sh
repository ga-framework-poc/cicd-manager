
#!/usr/bin/bash

set -ex

SYSTEM_DEFS_FILE=$(ls ${SYSTEM_DEFS_DIR}/${SYSTEM_NAME}.y*)
echo "SYSTEM_DEFS_FILE=${SYSTEM_DEFS_FILE}" >> ${GITHUB_ENV}

TEAM_NAME=$(yq '.team' "${SYSTEM_DEFS_FILE}")
echo "TEAM_NAME=${TEAM_NAME}" >> ${GITHUB_ENV}

DEV_BRANCH=$(yq '.branch' "${SYSTEM_DEFS_FILE}")
echo "DEV_BRANCH=${DEV_BRANCH}" >> ${GITHUB_ENV}

REPO_NAMES=$(yq '[.organization + "/" + .components[].repo]' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "REPO_NAMES=${REPO_NAMES}" >> ${GITHUB_ENV}

DEV_ENVIRONMENT=$(yq '.dev-environment' "${SYSTEM_DEFS_FILE}")
echo "DEV_ENVIRONMENT=${DEV_ENVIRONMENT}" >> ${GITHUB_ENV}

TEST_ENVIRONMENTS=$(yq '.test-environments' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "TEST_ENVIRONMENTS=${TEST_ENVIRONMENTS}" >> ${GITHUB_ENV}

RESOURCE_QUOTAS=$(yq '[.resource-quotas]' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "RESOURCE_QUOTAS=${RESOURCE_QUOTAS}" >> ${GITHUB_ENV}

set +ex