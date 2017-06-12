#!/bin/sh
#
#  Minio Cloud Storage, (C) 2017 Minio, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

setLogEnv() {
    export JS_LOG_DIRECTORY=$(echo ../../$LOG_DIR/${PWD##*/})
    export JS_ERROR_LOG_FILE=$(echo $JS_LOG_DIRECTORY/"error.log")
    export JS_LOG_FILE=$(echo $JS_LOG_DIRECTORY/"output.log")
}

prepareLogDir() {
    # clear old logs 
    rm -r echo $JS_LOG_DIRECTORY 2> /dev/null

    # create log directory
    mkdir $JS_LOG_DIRECTORY 2> /dev/null

    # create log files
    touch $JS_ERROR_LOG_FILE
    touch $JS_LOG_FILE
}

setUpTestClient() {
	npm i -g npm-check-updates
	npm-check-updates -u
	npm install
	npm link 

	export FUNCTIONAL_TEST_TRACE=$LOG_DIR/error.log
}

runTests() {
	npm test
}

# Setup log directories 
setLogEnv

# Create the log dir and files
prepareLogDir

# Build test file binary
setUpTestClient -s  2>&1  >| $JS_LOG_FILE

# run the tests
runTests -s  2>&1  >| $JS_LOG_FILE

grep -q 'Error:|FAIL' $JS_LOG_FILE > $JS_ERROR_LOG_FILE

exit 0
