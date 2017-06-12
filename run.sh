#!/usr/bin/env bash
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

ROOT_DIR="$PWD"
TEST_DIR="apps"

let "errorCounter = 0"

# Setup environment variables for the run.
setup() {
	set -e

	# If SERVER_ENDPOINT is not set the tests are run on play.minio.io by default.

	# SERVER_ENDPOINT is passed on as env variables while starting the docker container.
	# see README.md for info on options.
	if [ -z "$SERVER_ENDPOINT" ]; then
	    export SERVER_ENDPOINT="play.minio.io:9000"
	    export ACCESS_KEY="Q3AM3UQ867SPQQA43P2F"
	    export SECRET_KEY="zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"
	    export ENABLE_HTTPS=1
	fi

	# other env vars
	export S3_REGION="us-east1"  # needed for minio-java
	export LOG_DIR="log"
}

# Run the current SDK Test
currTest() {
	cd $TEST_DIR/$1
	chmod +x ./run.sh
	./run.sh  $ROOT_DIR  $TEST_DIR $(basename $1)
	cd ../..
}

# Cycle through the sdk directories and run sdk tests
runTests() {
	for i in $(yq  -r '.apps[]' $ROOT_DIR/config.yaml ); 
		do 
			f=$ROOT_DIR/$TEST_DIR/$i
			echo "running .... $f"
			if [ -d ${f} ]; then

		        # Will not run if no directories are available
		        SDK="$(basename $f)"

		        # Clear log directories before run.
		        #SDK_LOG_DIR=$ROOT_DIR/$LOG_DIR/$SDK/
		        #if [ ! -d $SDK_LOG_DIR ]
			  	#	then
			  	#		mkdir $SDK_LOG_DIR
			  	#	else 
			  	#		rm -rf $SDK_LOG_DIR/*
				#fi

				# Run test
				currTest "$SDK" #-s  2>&1  >| $SDK_LOG_DIR/"$SDK"_log.txt  
				
				# cat $SDK_LOG_DIR/"$sdk"_log.txt
				# Count failed runs
				#if [ -s "$SDK_LOG_DIR/error.log" ] 
		 		# then 
		     	#	let "errorCounter = errorCounter + 1" 
				# fi
			fi
		done
}

setup
runTests

#if [ $errorCounter -ne 0 ]; then 
#	exit 1
#fi

# exit 0