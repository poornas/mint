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

createBuckets_01(){
    echo "Running createBuckets_01" >> $MC_LOG_FILE
    # Make bucket
    ./mc mb target/testbucket1 &> /tmp/tempfile 

    if grep -q "<ERROR>" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_LOG_FILE
    fi

    echo "Testing if the bucket was created" >> $MC_LOG_FILE
    # list buckets
    ./mc ls target &> /tmp/tempfile

    if grep -q "testbucket1" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_LOG_FILE
        echo "Created testbucket1 successfully" >> $MC_LOG_FILE
    else
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    fi

    echo "Removing the bucket" >> $MC_LOG_FILE
    # remove bucket
    ./mc rm target/testbucket1 &> /tmp/tempfile

    if grep -q "<ERROR>" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_LOG_FILE
    fi   
}

createFile_02(){
    echo "Running createFile_02" >> $MC_LOG_FILE

    # Create a temp 2m file
    echo "Creating a 2mb temp file for upload" >> $MC_LOG_FILE
    truncate -s 2m /tmp/file

    # create a bucket
    echo "Creating a bucket" >> $MC_LOG_FILE
    ./mc mb target/testbucket1 &> /tmp/tempfile

    # copy the file
    echo "Uploading the 2mb temp file" >> $MC_LOG_FILE
    ./mc cp /tmp/file target/testbucket1 &> /tmp/tempfile 

    if grep -q "<ERROR>" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_LOG_FILE
    fi

    echo "Download the file" >> $MC_LOG_FILE
    ./mc cp target/testbucket1/file /tmp/file_downloaded &> /tmp/tempfile
    
    if grep -q "<ERROR>" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_LOG_FILE
    fi
    
    echo "Testing if the downloaded file is same as local file" >> $MC_LOG_FILE
    comm /tmp/file_downloaded /tmp/file &> /tmp/tempfile 

    if grep -q "differ" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_LOG_FILE
        echo "Error: files not equal" >> $MC_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
    fi

    echo "Removing the bucket" >> $MC_LOG_FILE
    # remove bucket
    ./mc rm --force --recursive target/testbucket1 &> /tmp/tempfile

    if grep -q "<ERROR>" /tmp/tempfile; then
        cat /tmp/tempfile >> $MC_ERROR_LOG_FILE
        exit 1
    else
        cat /tmp/tempfile >> $MC_LOG_FILE
    fi   
    
}

createBuckets_01
createFile_02