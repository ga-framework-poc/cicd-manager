#!/usr/bin/bash

set -ex

echo 'Generating build.yml for ${REPO_NAME}'
for F_NAME in $(find ${CICD_REPO_ONBOARDING_DIR}/.github-app-template/workflows -name "*.yml" -or -name "*.yaml")
do
    mv ${F_NAME} $(echo ${F_NAME} | sed -e "s/.yml$/-${TEAM_NAME}.yml/" -e "s/.yaml$/-${TEAM_NAME}.yaml/") ;
done

find ${CICD_REPO_ONBOARDING_DIR}/.github-app-template/workflows/ -type f \( -iname \*.yml -o -iname \*.yaml \) \
    -exec sed -i -e "s/%SYSTEM_NAME%/${SYSTEM_NAME}/g" \
                    -e "s/%TEAM_NAME%/${TEAM_NAME}/g" {} +

cp -RT ${CICD_REPO_ONBOARDING_DIR}/.github-app-template ${WORKING_DIR}/.github

git -C ${WORKING_DIR} add -u
if [[ ! -z "$(git -C ${WORKING_DIR} status --porcelain)" ]]
then
    git -C ${WORKING_DIR} config user.email ${cicd-team@my-org.com}
    git -C ${WORKING_DIR} config user.name ${GITHUB_ACTOR}
    git -C ${WORKING_DIR} add -A
    git -C ${WORKING_DIR} commit -am '[skip ci] installing latest cicd-manager GitHub Action Workflow(s)'
    git -C ${WORKING_DIR} push
    echo "Pushed ${WORKING_DIR}/.github to ${REPO_NAME}"
else
    echo "${REPO_NAME} is unchanged.  Skipping..."
fi

set +ex