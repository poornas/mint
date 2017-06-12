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
    export GO_LOG_DIRECTORY=$(echo ../../$LOG_DIR/${PWD##*/})
    export GO_ERROR_LOG_FILE=$(echo $GO_LOG_DIRECTORY/"error.log")
    export GO_LOG_FILE=$(echo $GO_LOG_DIRECTORY/"output.log")
}

prepareLogDir() {
    # clear old logs 
    rm -r echo $GO_LOG_DIRECTORY 2> /dev/null

    # create log directory
    mkdir $GO_LOG_DIRECTORY 2> /dev/null

    # create log files
    touch $GO_ERROR_LOG_FILE
    touch $GO_LOG_FILE
}

cleanUp(){
    # remove binary 
    rm minio.test
}

setUpTestClient() {
	go test -c api_functional_v4_test.go -o minio.test
}

runTests() {
	chmod +x ./minio.test
	./minio.test -test.short 
}

# Setup log directories 
setLogEnv

# Create the log dir and files
prepareLogDir

# Build test file binary
setUpTestClient -s  2>&1  >| $GO_LOG_FILE

# run the tests
runTests -s  2>&1  >| $GO_LOG_FILE

# Remove test binary
cleanUp

grep -q 'Error:|FAIL' $GO_LOG_FILE > $GO_ERROR_LOG_FILE
