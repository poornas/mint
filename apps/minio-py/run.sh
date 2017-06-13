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

build() {
	pip3 install --user -r requirements.txt
	pip3 install minio
}

run() {
	python3 ./functional_test.py $1 
}

main () {

    # Build test file binary
    build -s  2>&1  >| $1

    # run the tests
    run $1 2>&1  >| $1
    
    grep -q 'ERROR' $1 > $2

    return 0
}

# invoke the script
main "$@"

