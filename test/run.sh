#!/usr/bin/env sh
LOG_PREFIX="test/run"

echo "${LOG_PREFIX}.start"
export SRC_DIR=$PWD
export BUILD_ID=1
export BUILD_NAME='my-build'
export BUILD_JOB_NAME='my-build-job'
export BUILD_PIPELINE_NAME='my-build-pipeline'
export ATC_EXTERNAL_URL='127.0.0.1/atc'


cat $1 | /opt/resource/check

echo "${LOG_PREFIX}.end"
