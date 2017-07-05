#!/bin/bash
#
#  Mint (C) 2017 Minio, Inc.
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

set -e

_init() {
    MINIO_DOTNET_SDK_PATH="/mint/run/core/minio-dotnet"
    MINIO_DOTNET_SDK_VERSION="1.0.0"
}

# install java dependencies.
install() {
    cd "$MINIO_DOTNET_SDK_PATH"
    nuget install Minio.NetCore -Version  "$MINIO_DOTNET_SDK_VERSION"
}

# Compile test files
build() {
    cd "$MINIO_DOTNET_SDK_PATH"
    nuget install Minio.NetCore -Version 1.0.0
    dotnet restore 
    dotnet publish -c Release -o out 
}

main() {
    install
    build
}

_init "$@" && main
