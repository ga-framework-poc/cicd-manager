#!/usr/bin/bash

podman build --squash -t ${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG} -f ${WORKDIR}/Dockerfile