#!/usr/bin/bash

export JAVA_TOOL_OPTIONS=
if [[ -f $(dirname ${0})/settings.xml ]]
then
    mvn -s $(dirname ${0})/settings.xml -DskipTests --batch-mode clean package
else
    mvn -DskipTests --batch-mode clean package
fi