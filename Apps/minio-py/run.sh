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
    export PYTHON_LOG_DIRECTORY=$(echo ../../$LOG_DIR/${PWD##*/})
    export PYTHON_ERROR_LOG_FILE=$(echo $PYTHON_LOG_DIRECTORY/"error.log")
    export PYTHON_LOG_FILE=$(echo $PYTHON_LOG_DIRECTORY/"output.log")
}

prepareLogDir() {
    # clear old logs 
    rm -r echo $PYTHON_LOG_DIRECTORY 2> /dev/null

    # create log directory
    mkdir $PYTHON_LOG_DIRECTORY 2> /dev/null

    # create log files
    touch $PYTHON_ERROR_LOG_FILE
    touch $PYTHON_LOG_FILE
}

# This will be factored out when build environment is readied
setUpTestClient() {
	echo requirements.txt
	pip3 install --user -r requirements.txt
	pip3 install minio
}

# Run the test
runTests() {
	python3 ./functional_test.py "$LOG_DIR" 
}

# Setup log directories 
setLogEnv

# Create the log dir and files
prepareLogDir

# Build test file binary
setUpTestClient -s  2>&1  >| $PYTHON_LOG_FILE

# run the tests
runTests -s  2>&1  >| $PYTHON_LOG_FILE

# Remove test binary
cleanUp

grep -q 'ERROR' $PYTHON_LOG_FILE > $PYTHON_ERROR_LOG_FILE

